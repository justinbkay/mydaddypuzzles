class CreateEmailMessages < ActiveRecord::Migration
  def self.up
    create_table :email_messages do |t|
      t.column :from_email, :string
      t.column :subject, :string
      t.column :message, :text
    end
  end

  def self.down
    drop_table :email_messages
  end
end
