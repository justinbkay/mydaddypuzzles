class CartItem < ActiveRecord::Base
  attr_accessible :price, :quantity, :references, :references, :puzzle_config_id
  belongs_to :cart
  belongs_to :puzzle_config

  def title
    puzzle_config.puzzle.to_s + ' :: ' + puzzle_config.to_s
  end

end
