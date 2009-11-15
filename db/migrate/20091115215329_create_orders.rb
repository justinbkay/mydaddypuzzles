class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.column 'reference', :string
      t.column 'shipping', :string
      t.column 'total', :string
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
