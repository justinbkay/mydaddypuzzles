class AddOutOfStock < ActiveRecord::Migration
  def self.up
    add_column :configurations, :out_of_stock, :boolean
  end

  def self.down
    remove_column :table_name, :column_name
  end
end
