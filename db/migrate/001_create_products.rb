class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :price, :decimal,  :precision => 5, :scale => 2, :default => 0.0
      t.column :default_thumbnail, :string
      t.column :default_picture, :string
      t.column :size, :string
    end
  end

  def self.down
    drop_table :products
  end
end
