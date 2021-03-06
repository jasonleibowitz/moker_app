# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140515213011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
  end

  create_table "coffee_shops", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "avatar"
    t.string   "url"
    t.string   "phone_number"
    t.string   "hours"
    t.float    "rating"
    t.float    "wifi_rating"
    t.float    "outlet_rating"
    t.float    "workspace_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lon"
    t.float    "coffee_rating"
    t.string   "foursquare_id"
    t.integer  "total_wifi_reviews"
    t.integer  "total_wifi_upvotes"
    t.integer  "total_outlet_reviews"
    t.integer  "total_outlet_upvotes"
    t.integer  "total_workspace_reviews"
    t.integer  "total_workspace_upvotes"
    t.integer  "total_coffee_quality_reviews"
    t.integer  "total_coffee_quality_upvotes"
    t.float    "foursquare_rating"
  end

  create_table "foursquare_reviews", force: true do |t|
    t.string   "username"
    t.string   "user_pic"
    t.text     "comment"
    t.integer  "coffee_shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "coffee_shop_id"
    t.boolean  "wifi_rating"
    t.boolean  "outlet_rating"
    t.boolean  "workspace_rating"
    t.boolean  "coffee_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", force: true do |t|
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coffee_shop_id"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.string   "length"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "image"
    t.integer  "coffee_shop_id"
    t.datetime "check_in_time"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
