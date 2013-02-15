class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :puzzle_config
      t.references :cart
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :quantity

      t.timestamps
    end
  end
end
