class PuzzleConfig < ActiveRecord::Base
  self.table_name = 'configurations'
  belongs_to :puzzle
  has_many :line_items

  validates_presence_of :puzzle_id, :name, :default_thumbnail, :default_picture
  validates_numericality_of :price
  validates_uniqueness_of :default_thumbnail, :default_picture

  def to_s
    name
  end

  def default_configuration?
    self.puzzle.default_configuration == self.id ? true : false
  end

end
