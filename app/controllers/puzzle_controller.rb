class PuzzleController < ApplicationController
  #caches_page :index
  #caches_page :story
  #caches_page :gallery
  #caches_page :extreme_makeover
  include ActiveMerchant::Billing
  before_filter :return_cart

  def add_to_cart
    configuration = Configuration.find(params[:finish])
    @cart.add_puzzle(configuration)
    render :update do |page|
      page.replace_html 'cart', "#{image_tag('shopping_cart.png', :style => 'border: 0px;')} Cart total: #{number_to_currency(@cart.total)}<br /> #{link_to("Show Cart", :action => "show_cart")}"
      page.replace_html 'cart_status', "#{link_to(image_tag('shopping_cart.png', :style => 'border: 0px;'), :action => 'show_cart')} &nbsp;
			#{link_to(number_to_currency(@cart.total), :action => 'show_cart')}"
      page.show 'cart'
      page.visual_effect :highlight, 'cart'
      page.visual_effect :highlight, 'cart_status'
    end
  end

  def extreme_makeover
    render
  end

  def checkout
    cart = find_cart
    price = ((cart.total + cart.shipping_cost) * 100).to_i
    setup_response = gateway.setup_purchase(price,
      :ip                => request.remote_ip,
      :return_url        => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'show_cart', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def confirm
    redirect_to :action => 'index' unless params[:token]

    details_response = gateway.details_for(params[:token])

    @cart.customer = details_response.address

    @cart.customer['email'] = details_response.params['payer']

    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end

    @address = details_response.address
  end

  def complete
    cart = find_cart
    price = ((cart.total + cart.shipping_cost) * 100).to_i
    purchase = gateway.purchase(price,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )
    #raise purchase.inspect
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    else
      @order = Order.create(:reference => purchase.params['transaction_id'],
                            :shipping =>  cart.shipping_cost,
                            :total => cart.items.sum {|item| item.price},
                            :name => cart.customer['name'],
                            :address1 => cart.customer['address1'],
                            :address2 => cart.customer['address2'],
                            :company => cart.customer['company'],
                            :city => cart.customer['city'],
                            :state => cart.customer['state'],
                            :zip => cart.customer['zip'],
                            :country => cart.customer['country'],
                            :email => cart.customer['email'])
      cart.items.each do |i|
        @order.line_items << LineItem.create(:configuration_id => i.configuration.id, :quantity => i.quantity, :price => i.price)
      end

      # if there is a pickup lets give instructions
      if cart.shipping == '2'
        @instructions = "Items can be picked up weekday evenings after 7:30 pm or weekends between 8:00 am and 7:30 pm.  You will be contacted with directions via email."
      elsif cart.shipping == '3'
        @instructions = "Puzzles will be delivered to Valley Drive Preschool.  MyDaddyPuzzles will donate 20% of the proceeds to Valley Drive.  You will be contacted with details via email."
      elsif cart.shipping == '1'
        @instructions = 'Puzzles will be mailed via USPS.'
      end

      ContactMailer.deliver_order_to_fill(@order)
      session[:cart] = nil
      @cart.empty_items
    end
  end

  def empty_cart
    session[:cart] = nil
    redirect_to :action => :show_cart
  end

  def show_cart
    @page_title = 'Shopping Cart'
    @page_meta = 'MyDaddy Puzzles shopping cart for buying puzzles'
    @page_keywords = 'buy puzzles kids development'
  end

  def remove_item
    @configuration = Configuration.find(params[:id])
    @cart.remove_item(@configuration)
    redirect_to :action => :show_cart
  end

  def index
    @page_title = 'Handcrafted Wooden Puzzles'
    @page_meta = 'Handcrafted wooden puzzles made in the usa great for kids development and great gifts'
    @page_keywords = 'wooden puzzles made in usa wooden'
    @onsale = Puzzle.find(:all, :conditions => 'on_sale = 1', :order => 'name')
  end

  def display_picture
    @configuration = Configuration.find(params[:id])
    render :update do |page|
      page.replace_html 'image', image_tag("/images/full_size/#{@configuration.default_picture}")
      page.replace_html 'config_name', @configuration.name
    end
  end

  def story
    @page_title = 'Our Story'
    @page_meta = 'The story of how the company of MyDaddyPuzzles came to be'
    @page_keywords = 'puzzles story of the business'
    render
  end

  def news
    @stories = NewsStory.find(:all, :order => 'post_date desc')
    @page_title = 'News'
    @page_meta = 'Puzzles news items about where to get or see the product'
    @page_keywords = 'puzzle news wooden'
    render
  end

  def gallery
    @page_title = 'Puzzle Gallery'
    @page_meta = 'See wooden puzzle images here'
    @page_keywords = 'puzzles made in usa wooden images'
    @puzzles = Puzzle.active
    @configurations = @puzzles.map {|p| p.default_configurations }.flatten
  end

  def email_confirmation
    @page_title = 'Email Confirmation'
    render
  end

  def stories
    @page_title = 'Customer Stories'
    @page_meta = 'Stories of customers who enjoy their handcrafted wooden puzzles'
    @page_keywords = 'puzzles made in usa wooden'
    @stories = CustomerStory.find(:all, :conditions => 'active = 1', :order => 'created_at desc')
  end

  def store
    @page_title = 'Puzzle Store'
    @page_meta = 'Buy your very own wooden handcrafted puzzle here'
    @page_keywords = 'wooden puzzles made in usa store'
    @puzzles = Puzzle.find(:all, :conditions => 'active = 1', :order => 'on_sale desc')
  end

  def thanks
    @page_title = 'Thank you for your payment!'
  end

  # def update_store
  #    @configuration = Configuration.find(params[:id])
  #    render :update do |page|
  #      page.replace_html "price_#{params[:p]}", number_to_currency(@configuration.price)
  #      page.replace_html "picture_#{params[:p]}", link_to(image_tag(@configuration.default_thumbnail), :action => "images", :id => @configuration) + '<br />' + link_to("More Images", :action => "images", :id => @configuration)
  #    end
  #  end

  # def inventory
  #   @products = Product.find(:all, :conditions => 'active = 1')
  #   @cart = find_cart
  # end

  def images
    @page_title = 'Puzzle Pictures'
    @configuration = Configuration.find(params[:id])
    @puzzle = @configuration.puzzle
  end

  def made_in_usa
    @page_title = 'Made in the USA'
    @page_meta = 'Our puzzles are made in the usa with usa products and materials'
    @page_keywords = 'wooden handcrafted puzzles made in usa'
  end

  def contact
    @page_title = 'Contact MyDaddypuzzles'
    @page_meta = 'Contact us about your puzzle needs'
    @page_keywords = 'puzzles made in usa wooden'
    if request.post?
      @email_message = EmailMessage.new(params[:email_message])
      if @email_message.save
        ContactMailer.contact_us(@email_message).deliver
        redirect_to :action => :email_confirmation
      else
        render :action => :contact
      end
    else
      @email_message = EmailMessage.new()
    end
  end

  def give_away
    @page_title = 'Monthly Drawing Entry'
    @page_meta = 'Enter to win a free puzzle monthly in our drawing'
    @page_keywords = 'puzzles made in usa wooden'
    @entry = Entry.new(:month => Date.today.strftime("%B"))
    @prize = Prize.find(:first, :conditions => ['month = ?', Date.today.month])
    @puzzle = Configuration.find(@prize.puzzle_id)
  end

  def record_entry
    @entry = Entry.new(params[:entry])
    if @entry.save
      ContactMailer.deliver_enter_drawing(@entry)
      redirect_to :action => :drawing_confirmation
    else
      render :action => :give_away
    end
  end

  def drawing_confirmation
    @page_title = 'Monthly Drawing Confirmation'
    render
  end

  def change_shipping
    @cart.shipping = params[:id]
    case params[:id]
    when '1' then desc = "(Shipped via the United States Postal Service)"
    when '2' then desc = "(Order to be picked-up at MyDaddyPuzzles)"
    when '3' then desc = "(Order to be picked-up at Valley Drive Preschool)"
    else
      desc ="(Shipped via the United States Postal Service)"
    end
    render :update do |page|
      page.replace_html 'ship_desc', desc
    end
  end

private
  def gateway
    if RAILS_ENV == 'production'
      login = 'mydaddypuzzles_api1.gmail.com'
      password = 'XMVXDN6DBBKLA2S7'
      signature = 'AFcWxV21C7fd0v3bYYYRCpSSRl31AZHDiRvUxQHKgHjRTRQr9FCGiYeu'
    else
      login = 'ryan_1258078809_biz_api1.gmail.com'
      password = '1258078814'
      signature = 'AO84zOzoAqax-rHP-gFjqDnBjuzkAohS6iWGsgfm1AW6zCPOxZwRYE2f'
    end
    @gateway ||= PaypalExpressGateway.new(
      :login => login,
      :password => password,
      :signature => signature
    )
  end

  def return_cart
    @cart = find_cart
  end

  def find_cart
    session[:cart] ||= Cart.new
  end

end
