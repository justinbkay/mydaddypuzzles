class CartItem < ActiveRecord::Base
  attr_accessible :price, :quantity, :references, :references, :puzzle_config_id
end
