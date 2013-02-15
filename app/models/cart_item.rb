class CartItem < ActiveRecord::Base
  attr_accessible :price, :quantity, :references, :references
end
