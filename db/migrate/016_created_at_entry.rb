class CreatedAtEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :created_at, :datetime
  end

  def self.down
    remove_column :entries, :created_at
  end
end
