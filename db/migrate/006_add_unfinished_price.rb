class AddUnfinishedPrice < ActiveRecord::Migration
  def self.up
    add_column :products, :unfinished_price, :decimal, :precision => 5, :scale => 2
  end

  def self.down
    remove_column :products, :unfinished_price
  end
end
