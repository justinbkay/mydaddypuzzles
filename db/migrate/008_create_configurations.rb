class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.column :puzzle_id, :integer
      t.column :name, :string
      t.column :default_thumbnail, :string
      t.column :default_picture, :string
      t.column :price, :decimal,  :precision => 5, :scale => 2, :default => 0.0
      t.column :active, :boolean
    end
  end

  def self.down
    drop_table :configurations
  end
end
