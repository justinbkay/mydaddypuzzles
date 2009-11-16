class AddCustmer < ActiveRecord::Migration
  def self.up
    add_column :orders, :name, :string
    add_column :orders, :company, :string
    add_column :orders, :address1, :string
    add_column :orders, :address2, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :zip, :string
    add_column :orders, :country, :string
    add_column :orders, :email, :string
  end

  def self.down
    remove_column :orders, :email
    remove_column :orders, :country
    remove_column :orders, :zip
    remove_column :orders, :state
    remove_column :orders, :city
    remove_column :orders, :address2
    remove_column :orders, :address1
    remove_column :orders, :company
    remove_column :orders, :name
  end
end
