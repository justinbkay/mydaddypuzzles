class AdminController < ApplicationController
  before_filter :security, :except => [:login]
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  def login
    if request.post?
      if params[:username] == 'puzzlemaster' && params[:secret] == 'polysci'
        session[:admin] = 1
        redirect_to :action => :index
      else
        flash[:notice] = "Invalid Credentials"
      end
    end
  end
  
  def logout
    session[:admin] = nil
    flash[:notice] = "Logged Out"
    redirect_to :action => :login
  end

################## Puzzles ########################

  def list_puzzles
    @puzzles = Puzzle.find(:all, :order => 'name')
  end

  def new_puzzle
    @puzzle = Puzzle.new
  end

  def create_puzzle
    @puzzle = Puzzle.new(params[:puzzle])
    if @puzzle.save
      flash[:notice] = 'The Puzzle was successfully created.'
      redirect_to :action => 'list_puzzles'
    else
      render :action => 'new_puzzle'
    end
  end

  def edit_puzzle
    @puzzle = Puzzle.find(params[:id])
  end

  def update_puzzle
    @puzzle = Puzzle.find(params[:id])
    if @puzzle.update_attributes(params[:puzzle])
      flash[:notice] = "Puzzle Updated Successfully"
      redirect_to :action => :list_puzzles
    else
      render :action => :edit_puzzle
    end
  end

  def show_configurations
    @puzzle = Puzzle.find(params[:id])
  end
  
  def new_configuration
    @puzzle = Puzzle.find(params[:id])
    @configuration = Configuration.new
  end
  
  def create_configuration
    @puzzle = Puzzle.find(params[:configuration][:puzzle_id])
    @configuration = Configuration.new(params[:configuration])
    
    @configuration.default_thumbnail = base_part_of(params[:default_thumbnail].original_filename)
    @configuration.default_picture = base_part_of(params[:default_picture].original_filename)
    
    save_file(@configuration.default_thumbnail,params[:default_thumbnail].read, 1)
		save_file(@configuration.default_picture, params[:default_picture].read)
		
		if @configuration.save
      flash[:notice] = 'Configuration was successfully created.'
      redirect_to :action => 'show_configurations', :id => @configuration.puzzle_id
    else
      render :action => 'new_configuration'
    end
    
  rescue NoMethodError
    flash[:notice] = "It appears that you didn't select a file"
    render :action => 'new_configuration'
  end
  
  def edit_configuration
    @configuration = Configuration.find(params[:id])
    @puzzle = @configuration.puzzle
  end
  
  def update_configuration
    @configuration = Configuration.find(params[:id])
    	
    if @configuration.update_attributes(params[:configuration])
      begin
        unless params[:default_thumbnail].original_filename.nil?
          unless @configuration.default_thumbnail == params[:default_thumbnail].original_filename
            remove_file(@configuration.default_thumbnail,1)
          end
          save_file(params[:default_thumbnail].original_filename,params[:default_thumbnail].read, 1)
          @configuration.update_attribute(:default_thumbnail,params[:default_thumbnail].original_filename)
        end
      rescue
        # let it pass
      end
      
      begin
        unless params[:default_picture].original_filename.nil?
          unless @configuration.default_picture == params[:default_picture].original_filename
              remove_file(@configuration.default_picture)
          end
          save_file(params[:default_picture].original_filename, params[:default_picture].read)
          @configuration.update_attribute(:default_picture,params[:default_picture].original_filename)
        end
      rescue
        #let it pass
      end
      
      # if we set the config to inactive, lets make sure that it is not the default config
      unless @configuration.active?
        if @configuration.puzzle.default_configuration == @configuration.id
          @configuration.puzzle.default_configuration = nil
          @configuration.puzzle.save!
        end
      end
      
      flash[:notice] = 'Configuration was successfully updated.'
      redirect_to :action => 'show_configurations', :id => @configuration.puzzle_id
    else
      render :action => 'edit_configuration'
    end
  end
################# End Puzzles #####################

  def index
    list_puzzles
    render :action => 'list_puzzles'
  end

############### stories

  def list_stories
    @stories = CustomerStory.find(:all)
  end
  
  def new_story
    @customer_story = CustomerStory.new
  end
  
  def create_story
    @customer_story = CustomerStory.create(params[:customer_story])
    
    if @customer_story.save
      flash[:notice] = 'Story Created!'
      redirect_to :action => :list_stories
    else
      render :action => :new_story
    end
  end
  
  def edit_story
    @customer_story = CustomerStory.find(params[:id])
  end
  
  def update_story
    @customer_story = CustomerStory.find(params[:id])
    
    if @customer_story.update_attributes(params[:customer_story])
      flash[:notice] = "Story updated!"
      redirect_to :action => :list_stories
    else
      render :action => :edit_story
    end
  end

######## end stories

##### Start News #######

  def new_news
    @news_story = NewsStory.new
  end

  def list_news
    @news_stories = NewsStory.find(:all, :order => 'created_at')
  end

  def edit_news
    @news_story = NewsStory.find(params[:id])
  end

  def create_news
    @news_story = NewsStory.new(params[:news_story])
    #raise params.inspect
    begin
      @news_story.picture = params[:news_picture].original_filename
      save_file(params[:news_picture].original_filename,params[:news_picture].read, 2)
    rescue
      # do nothing on error
    end
    
    if @news_story.save 
      flash[:notice] = "Article Successfully created..."
      redirect_to :action => :list_news
    else
      render :action => :new_news
    end
  end

  def update_news
    @news_story = NewsStory.find(params[:id])
    if @news_story.update_attributes(params[:news_story])
      begin
        unless params[:news_picture].original_filename.nil?
          unless @news_story.picture == params[:news_picture].original_filename || @news_story.picture.nil?
            remove_file(@news_story.picture,2)
          end
          save_file(params[:news_picture].original_filename,params[:news_picture].read, 2)
          @news_story.update_attribute(:picture,params[:news_picture].original_filename)
        end
      rescue
        # let it pass
      end
      redirect_to :action => :list_news
    else
      render :action => :edit_news
    end
  end

##### end news #########


private
  def base_part_of(file_name)
  	name = File.basename(file_name)
  	name.gsub(/[^\w._-]/, '')
  end
  
  def save_file(filename, data, thumbnail=nil)
    if thumbnail == 1
      @rails_root = File.expand_path(RAILS_ROOT) + '/public/images/thumbnails/' + filename
    elsif thumbnail == 2
      @rails_root = File.expand_path(RAILS_ROOT) + '/public/images/articles/' + filename
    else
      @rails_root = File.expand_path(RAILS_ROOT) + '/public/images/full_size/' + filename
    end
    fh = File.new("#{@rails_root}", "w")
		fh.print data
		fh.close
  end
  
  def remove_file(filename, thumbnail=nil)
    if thumbnail == 1 
      @rails_root = File.expand_path(RAILS_ROOT) + '/public/images/thumbnails/' + filename
    elsif thumbnail == 2
      @rails_root = File.expand_path(RAILS_ROOT) + '/public/images/articles/' + filename
    else
      @rails_root = File.expand_path(RAILS_ROOT) + '/public/images/full_size/' + filename
    end
    unless filename =~ /^\.\./
      logger.warn "Deleting file #{filename}"
      File.delete @rails_root
    else
      raise 'Don\'t be tryin\' that! ' + filename
    end
  end
end
