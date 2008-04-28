class CreateNewsStories < ActiveRecord::Migration
  def self.up
    create_table :news_stories do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :picture, :string
      t.column :post_date, :date
      t.timestamps
    end
  end

  def self.down
    drop_table :news_stories
  end
end
