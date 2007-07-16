class AddNameEmailMessage < ActiveRecord::Migration
  def self.up
    add_column :email_messages, :name, :string
  end

  def self.down
    remove_column :email_messages, :name
  end
end
