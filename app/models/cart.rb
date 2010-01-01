class Cart
  attr_reader :items
  attr_accessor :customer, :shipping
  
  def initialize
    @items = []
    @shipping = '1'
  end
  
  def add_puzzle(configuration)
    current_item = @items.find {|item| item.configuration == configuration}
    if current_item
      current_item.increment_quantity
    else
      @items << CartItem.new(configuration)
    end
  end
  
  def remove_item(configuration)
    @items.delete_if {|i| i.configuration == configuration }
  end
  
  def total_items
    @items.inject(0) {|sum, t| sum + t.quantity}
  end
  
  def total
    @items.sum {|item| item.price}
  end
  
  def shipping_cost
    # if total items is odd lets add 1
    return 0 unless @shipping == '1'
    
    # if usps is shipping we return calc'd shipping
    ti = total_items
    ti = ti % 2 == 1 ? ti += 1 : ti
    if ti < 3
      8
    else
      ((ti - 2) * 2) + 8
    end
  end
  
  def empty_items
    @items = []
  end
  
end