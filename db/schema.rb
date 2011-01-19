# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110114202556) do

  create_table "admin_tool_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "roles_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_tool_users", ["email"], :name => "index_admin_tool_users_on_email", :unique => true
  add_index "admin_tool_users", ["reset_password_token"], :name => "index_admin_tool_users_on_reset_password_token", :unique => true

  create_table "cities", :force => true do |t|
    t.string   "name",                  :limit => 20,  :default => "", :null => false
    t.string   "long_name",             :limit => 40,  :default => "", :null => false
    t.string   "description",           :limit => 360, :default => "", :null => false
    t.integer  "job_id",                :limit => 8
    t.string   "battle_background_url", :limit => 200, :default => "", :null => false
    t.datetime "available_on"
    t.datetime "available_until"
  end

  create_table "items", :force => true do |t|
    t.integer  "app_id",                                                          :default => 1,     :null => false
    t.string   "name",               :limit => 60
    t.text     "description"
    t.integer  "type",                                                                               :null => false
    t.decimal  "price",                             :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.string   "currency_type",      :limit => 6,                                 :default => "1",   :null => false
    t.decimal  "upkeep",                            :precision => 5, :scale => 2, :default => 0.0,   :null => false
    t.integer  "attack",             :limit => 2,                                 :default => 0,     :null => false
    t.integer  "defense",                                                         :default => 0,     :null => false
    t.integer  "agility",            :limit => 2,                                 :default => 0,     :null => false
    t.integer  "num_available",                                                   :default => -1,    :null => false
    t.datetime "available_on"
    t.datetime "available_until"
    t.integer  "level",                                                           :default => 1,     :null => false
    t.integer  "ability_element_id", :limit => 2,                                 :default => 0,     :null => false
    t.integer  "rarity",                                                          :default => 2,     :null => false
    t.string   "photo",              :limit => 200
    t.string   "swf"
    t.integer  "item_category_id",                                                :default => 0,     :null => false
    t.integer  "city"
    t.integer  "sort"
    t.integer  "class"
    t.integer  "force_show_card",    :limit => 1,                                 :default => 0
    t.integer  "i_can_has",          :limit => 2
    t.boolean  "sell_isolated",                                                   :default => false
    t.integer  "apply_discount",     :limit => 1,                                 :default => 1,     :null => false
  end

  add_index "items", ["ability_element_id"], :name => "ability_element_id"
  add_index "items", ["app_id", "type"], :name => "app_id"
  add_index "items", ["city"], :name => "city"
  add_index "items", ["level"], :name => "level"
  add_index "items", ["rarity"], :name => "rarity"

  create_table "pieces", :force => true do |t|
    t.string   "name",               :default => "", :null => false
    t.text     "description"
    t.integer  "attack"
    t.integer  "defense"
    t.integer  "movement"
    t.integer  "cost"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
