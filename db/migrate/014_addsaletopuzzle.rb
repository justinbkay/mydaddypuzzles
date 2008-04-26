class Addsaletopuzzle < ActiveRecord::Migration
  def self.up
    add_column :puzzles, :on_sale, :boolean, :default => false
  end

  def self.down
  end
end
