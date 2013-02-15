class Cart < ActiveRecord::Base
  has_many :cart_items

  def add_puzzle(puzzle)
    current_item = self.cart_items.find { |item| item.puzzle_config_id == puzzle.id }
    if current_item
      current_item.increment_quantity
    else
      self.cart_items << CartItem.new(:puzzle_config_id => puzzle.id, :price => puzzle.price, :quantity => 1)
    end
  end

  def total
    self.cart_items.map(&:price).reduce(&:+)
  end

end
