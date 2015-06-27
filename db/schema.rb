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

ActiveRecord::Schema.define(version: 20150627164946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.float    "subtotal",            default: 0.0
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "tax",                 default: 0.0
    t.float    "tip",                 default: 0.0
    t.float    "discount",            default: 0.0
    t.string   "charged_to_venmo_id"
    t.string   "charged_by_venmo_id"
    t.string   "payment_source"
    t.string   "payment_id"
    t.float    "delivery",            default: 0.0
    t.float    "total",               default: 0.0
  end

  create_table "contacts", force: true do |t|
    t.integer  "user_id"
    t.string   "venmo_id"
    t.string   "username"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "charge_id"
    t.float    "subtotal",           default: 0.0
    t.float    "tax",                default: 0.0
    t.float    "tip",                default: 0.0
    t.float    "delivery",           default: 0.0
    t.float    "discount",           default: 0.0
    t.float    "total",              default: 0.0
    t.string   "charge_to_nickname"
    t.string   "charge_to_venmo"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "site"
    t.text     "original_text"
    t.string   "restaurant"
    t.string   "order_number"
    t.float    "total",         default: 0.0
    t.float    "tip",           default: 0.0
    t.float    "tax",           default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "discount",      default: 0.0
    t.float    "delivery",      default: 0.0
    t.float    "subtotal",      default: 0.0
  end

  create_table "users", force: true do |t|
    t.string   "venmo_id"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "access_token"
    t.datetime "access_token_expires_at"
    t.string   "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
