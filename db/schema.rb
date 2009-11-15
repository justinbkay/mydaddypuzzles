# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091115215520) do

  create_table "configurations", :force => true do |t|
    t.integer "puzzle_id"
    t.string  "name"
    t.string  "default_thumbnail"
    t.string  "default_picture"
    t.decimal "price",             :precision => 5, :scale => 2, :default => 0.0
    t.boolean "active"
    t.boolean "out_of_stock"
    t.boolean "on_sale",                                         :default => false
  end

  create_table "customer_stories", :force => true do |t|
    t.string   "customer_name"
    t.text     "story"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_messages", :force => true do |t|
    t.string "from_email"
    t.string "subject"
    t.text   "message"
    t.string "name"
  end

  create_table "entries", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "month"
    t.datetime "created_at"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "configuration_id"
    t.string   "quantity"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_stories", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "picture"
    t.date     "post_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string   "reference"
    t.string   "shipping"
    t.string   "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prizes", :force => true do |t|
    t.integer  "month"
    t.integer  "puzzle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "puzzles", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.string  "size"
    t.boolean "active"
    t.integer "default_configuration"
    t.boolean "on_sale",               :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
