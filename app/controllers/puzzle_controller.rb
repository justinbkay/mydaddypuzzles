class PuzzleController < ApplicationController

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

  def empty_cart
    session[:cart] = nil
    redirect_to :action => :show_cart
  end

  def show_cart
    @cart = find_cart
  end

  def remove_item
    @configuration = Configuration.find(params[:id])
    @cart = find_cart
    @cart.remove_item(@configuration)
    redirect_to :action => :show_cart
  end

  def index
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
  end

  def gallery
    render
  end
  
  def gallery_xml
    @configurations = Configuration.find(:all, :conditions => 'active = 1')
    render :layout => false
  end
  
  def email_confirmation
    render
  end
  
  def stories
    @stories = CustomerStory.find(:all, :conditions => 'active = 1')
  end

  def store
    @puzzles = Puzzle.find(:all, :conditions => 'active = 1')
    @cart = find_cart
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
    @configuration = Configuration.find(params[:id])
    @puzzle = @configuration.puzzle
  end

  def contact
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
end
