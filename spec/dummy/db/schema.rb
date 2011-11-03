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

ActiveRecord::Schema.define(:version => 20111103195213) do

  create_table "fassets_core_assets", :force => true do |t|
    t.string   "name"
    t.boolean  "public"
    t.integer  "content_id"
    t.string   "content_type"
    t.integer  "user_id"
    t.integer  "classifications_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fassets_core_catalogs", :force => true do |t|
    t.string "title"
    t.string "permalink"
    t.text   "info"
  end

  create_table "fassets_core_classifications", :force => true do |t|
    t.integer "catalog_id"
    t.integer "asset_id"
  end

  create_table "fassets_core_facets", :force => true do |t|
    t.string  "caption"
    t.string  "color"
    t.string  "order"
    t.integer "catalog_id"
    t.string  "label_order"
  end

  create_table "fassets_core_file_assets", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.integer  "file_width"
    t.integer  "file_height"
    t.datetime "file_updated_at"
  end

  create_table "fassets_core_labelings", :force => true do |t|
    t.integer "classification_id"
    t.integer "label_id"
  end

  create_table "fassets_core_labels", :force => true do |t|
    t.string  "caption"
    t.integer "facet_id"
    t.integer "position"
    t.integer "value"
  end

  create_table "fassets_core_tray_positions", :force => true do |t|
    t.integer "user_id"
    t.integer "position"
    t.integer "asset_id"
    t.string  "clipboard_type"
    t.integer "clipboard_id"
  end

  create_table "fassets_core_urls", :force => true do |t|
    t.string "url"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
