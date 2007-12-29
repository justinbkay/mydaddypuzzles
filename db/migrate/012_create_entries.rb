class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.column :name, :string
      t.column :address, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :phone, :string
      t.column :email, :string
      t.column :month, :string
    end
  end

  def self.down
    drop_table :entries
  end
end
