class AddSaleFlag < ActiveRecord::Migration
  def self.up
    add_column :configurations, :on_sale, :boolean, :default => false
  end

  def self.down
    remove_column :configurations, :on_sale
  end
end
