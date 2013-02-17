class Cart < ActiveRecord::Base
  attr_accessible :session_id

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
    self.cart_items.map(&:total).reduce(&:+)
  end

  def shipping_cost
    # if total items is odd lets add 1
    return 0 unless @shipping == '1'

    # if usps is shipping we return calc'd shipping
    ti = cart_items.size
    ti = ti % 2 == 1 ? ti += 1 : ti
    if ti < 3
      8
    else
      ((ti - 2) * 2) + 8
    end
  end

  def remove_item(configuration)
    self.cart_items.where(:puzzle_config_id => configuration).delete_all
  end

end
