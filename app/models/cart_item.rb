class CartItem
  attr_reader :configuration, :quantity, :price, :puzzle
  
  def initialize(configuration)
    @puzzle = configuration.puzzle
    @quantity = 1
    @price = configuration.price
    @configuration = configuration
  end
  
  def increment_quantity
    @quantity += 1
  end
  
  def title
    @puzzle.to_s + ' :: ' + @configuration.to_s
  end
  
  def price
    @price * @quantity
  end

end