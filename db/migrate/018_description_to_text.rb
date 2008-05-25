class DescriptionToText < ActiveRecord::Migration
  def self.up
    change_column :puzzles, :description, :text
  end

  def self.down
  end
end
