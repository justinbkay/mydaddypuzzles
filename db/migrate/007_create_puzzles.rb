class CreatePuzzles < ActiveRecord::Migration
  def self.up
    create_table :puzzles do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :size, :string
      t.column :active, :boolean
      t.column :default_configuration, :integer
    end
  end

  def self.down
    drop_table :puzzles
  end
end
