class Cart
  attr_reader :items
  
  def initialize
    @items = []
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
  
end