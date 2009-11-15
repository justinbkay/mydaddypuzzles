class Configuration < ActiveRecord::Base
  belongs_to :puzzle
  has_many :line_items
  
  validates_presence_of :puzzle_id, :name, :default_thumbnail, :default_picture
  validates_numericality_of :price
  validates_uniqueness_of :default_thumbnail, :default_picture
  
  def to_s
    name
  end
end
