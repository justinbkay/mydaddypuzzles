class AddColorStain < ActiveRecord::Migration
  def self.up
    add_column :products, :default_colored, :string
  end

  def self.down
    remove_column :products, :default_colored
  end
end
