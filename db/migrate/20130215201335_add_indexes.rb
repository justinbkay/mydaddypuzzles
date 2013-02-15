class AddIndexes < ActiveRecord::Migration
  def up
    add_index "cart_items", ["cart_id", "puzzle_config_id"], :name => "index_cart_items_on_cart_id_puzzle_id"
  end

  def down
  end
end
