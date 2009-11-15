class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.column 'order_id', :integer
      t.column 'configuration_id', :integer
      t.column 'quantity', :string
      t.column 'price', :string
      t.timestamps
    end
  end

  def self.down
    drop_table :line_items
  end
end
