#encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#MarketData.create(:security_code => 'USDJPY', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160125, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => 'ドル円')
#MarketData.create(:security_code => 'EURJPY', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160125, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => 'ユーロ円')
#MarketData.create(:security_code => 'AUDJPY', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160125, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => '豪ドル円')
#MarketData.create(:security_code => 'GBPJPY', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160125, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => 'ポンド円')
#MarketData.create(:security_code => 'EURUSD', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160125, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => 'ユーロドル')
#MarketData.create(:security_code => 'AUDUSD', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160125, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => '豪ドルドル')
#MarketData.create(:security_code => 'GBPUSD', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160125, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => 'ポンドドル')
#MarketData.create(:security_code => 'NZDJPY', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160326, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => 'ニュージーランド円')
#MarketData.create(:security_code => 'CADJPY', :vendor_code => '01', :market_code => 'DMY', :from_date => 20160326, :to_date => 99991231, :asset_class =>'FX', :region_code => 'DMY', :security_name => 'カナダドル円')

require "csv"

#CSV.foreach('db/TRYJPY.csv') do |row|
#  FxRate.create!(trade_date: row[0], open_price: row[1], high_price: row[2], low_price: row[3], close_price: row[4],prev_price: row[5], product_code1: '01', product_code2: 'TRY/JPY', product_name: 'トルコリラ', data_kbn: 'D01')
#end

FxRate.destroy_all("product_code2 like 'TRY%'")

CSV.foreach('db/TRYJPY2.csv') do |row|
  FxRate.create!(product_code2: row[0], product_name: row[1], trade_date: row[2], prev_price: row[3],
   open_price: row[4], high_price: row[5], low_price: row[6], close_price: row[7],
   today_price: row[8], prev_changes: row[9], swap: row[10], trade_quantity: row[11], position_quantity: row[12],
   product_code1: '01', data_kbn: 'D01')
end
