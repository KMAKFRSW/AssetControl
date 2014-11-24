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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141122135536) do

  create_table "fx_performances", :force => true do |t|
    t.string   "cur_code"
    t.string   "calc_date"
    t.string   "item"
    t.string   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fx_rates", :force => true do |t|
    t.string   "data_kbn"
    t.string   "trade_date"
    t.string   "product_code1"
    t.string   "product_code2"
    t.string   "product_name"
    t.string   "prev_price"
    t.string   "open_price"
    t.string   "open_price_time"
    t.string   "high_price"
    t.string   "high_price_time"
    t.string   "low_price"
    t.string   "low_price_time"
    t.string   "close_price"
    t.string   "close_price_time"
    t.string   "today_price"
    t.string   "prev_changes"
    t.string   "swap"
    t.string   "trade_quantity"
    t.string   "position_quantity"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "fx_trade", :force => true do |t|
    t.string   "order_no"
    t.string   "trade_date"
    t.string   "position_no"
    t.string   "currency"
    t.string   "trade_type"
    t.string   "quantity"
    t.decimal  "price",         :precision => 10, :scale => 3
    t.decimal  "commission",    :precision => 10, :scale => 0
    t.decimal  "sw_gain",       :precision => 10, :scale => 0
    t.decimal  "realized_gain", :precision => 10, :scale => 0
    t.decimal  "sum_gain",      :precision => 10, :scale => 0
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
