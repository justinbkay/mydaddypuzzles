class Prize < ActiveRecord::Base
  attr_accessible :month
  belongs_to :puzzle
end
