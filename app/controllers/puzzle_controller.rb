class PuzzleController < ApplicationController
  #caches_page :index 
  #caches_page :story
  #caches_page :gallery
  #caches_page :extreme_makeover
  
  def add_to_cart
    @cart = find_cart
    configuration = Configuration.find(params[:finish])
    @cart.add_puzzle(configuration)
    render :update do |page|
      page.replace_html 'cart', "Shopping Cart total: #{number_to_currency(@cart.items.sum {|item| item.price})} #{link_to("Show Cart", :action => "show_cart")}"
      page.show 'cart' 
      page.visual_effect :highlight, 'cart'
    end
  end

  def extreme_makeover
    render
  end
  
  def empty_cart
    session[:cart] = nil
    redirect_to :action => :show_cart
  end

  def show_cart
    @page_title = 'Shopping Cart'
    @page_meta = 'MyDaddy Puzzles shopping cart for buying puzzles'
    @page_keywords = 'buy puzzles kids development'
    @cart = find_cart
  end

  def remove_item
    @configuration = Configuration.find(params[:id])
    @cart = find_cart
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
  
  def find_cart
    session[:cart] ||= Cart.new
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
    render
  end
  
  def gallery_xml
    @configurations = Configuration.find(:all, :conditions => 'active = 1')
    render :layout => false
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
    @cart = find_cart
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
        ContactMailer.deliver_contact_us(@email_message)
        redirect_to :action => :email_confirmation
      else
        render :action => :contact
      end
    else
      @email = EmailMessage.new()
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
end
