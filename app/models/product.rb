class Product < ActiveRecord::Base
  
  validates_presence_of :name, :description, :price, :default_thumbnail, :default_picture, :size
  validates_uniqueness_of :name
  #validates_format_of :default_thumbnail, :with => %r{\.(gif|jpg|png)$}i, :message => "must be an image file: png, jpg, or gif"
  
end
