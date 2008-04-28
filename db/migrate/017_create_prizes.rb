class CreatePrizes < ActiveRecord::Migration
  def self.up
    create_table :prizes do |t|
      t.column :month, :integer
      t.column :puzzle_id, :integer
      t.timestamps
    end
    (1..12).each do |i|
      Prize.create(:month => i)
    end
    Prize.find(4).update_attribute(:puzzle_id, 1)
  end

  def self.down
    drop_table :prizes
  end
end
