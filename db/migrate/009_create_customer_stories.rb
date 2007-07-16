class CreateCustomerStories < ActiveRecord::Migration
  def self.up
    create_table :customer_stories do |t|
      t.column :customer_name, :string
      t.column :story, :text
      t.column :active, :boolean
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :customer_stories
  end
end
