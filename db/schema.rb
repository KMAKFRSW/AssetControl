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

ActiveRecord::Schema.define(:version => 20160314143700) do

  create_table "alert_mails", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.string   "to"
    t.string   "from"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "body1"
    t.text     "body2"
    t.string   "status"
  end

  create_table "alerts", :force => true do |t|
    t.integer  "user_id"
    t.string   "code"
    t.string   "alertvalue"
    t.text     "memo"
    t.string   "checkrule"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bolinger_bands", :force => true do |t|
    t.string   "calc_date"
    t.string   "cur_code"
    t.string   "term"
    t.string   "MA"
    t.string   "plus1sigma"
    t.string   "plus2sigma"
    t.string   "plus3sigma"
    t.string   "minus1sigma"
    t.string   "minus2sigma"
    t.string   "minus3sigma"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "dairies", :force => true do |t|
    t.integer  "user_id"
    t.string   "trade_date"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "difference_from_mas", :force => true do |t|
    t.string   "calc_date"
    t.string   "cur_code"
    t.string   "term"
    t.string   "DFMA"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "market_data", :force => true do |t|
    t.string   "security_code"
    t.string   "vendor_code"
    t.string   "market_code"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "asset_class"
    t.string   "region_code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "security_name"
  end

  create_table "market_data_prices", :force => true do |t|
    t.string   "security_code"
    t.string   "vendor_code"
    t.string   "market_code"
    t.date     "trade_date"
    t.string   "item"
    t.string   "data"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "pivots", :force => true do |t|
    t.string   "calc_date"
    t.string   "cur_code"
    t.string   "cycle"
    t.string   "P"
    t.string   "R1"
    t.string   "R2"
    t.string   "R3"
    t.string   "S1"
    t.string   "S2"
    t.string   "S3"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rsis", :force => true do |t|
    t.string   "calc_date"
    t.string   "cur_code"
    t.string   "term"
    t.string   "RSI"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stochastics", :force => true do |t|
    t.string   "calc_date"
    t.string   "cur_code"
    t.string   "kterm"
    t.string   "dterm"
    t.string   "K"
    t.string   "D"
    t.string   "SD"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
