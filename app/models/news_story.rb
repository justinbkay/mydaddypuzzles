class NewsStory < ActiveRecord::Base
  validates_presence_of :title, :body, :post_date
  
  
end
