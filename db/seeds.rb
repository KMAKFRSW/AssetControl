#encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

MarketData.create(:security_code => '^DJI', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AM', :security_name => 'NY Dow')
MarketData.create(:security_code => '^IXIC', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AM', :security_name => 'NASDAQ')
MarketData.create(:security_code => '^GSPC', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AM', :security_name => 'S&P 500')
MarketData.create(:security_code => '^FTSE', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'EU', :security_name => 'FTSE 100')
MarketData.create(:security_code => '^GDAXI', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'EU', :security_name => 'DAX')
MarketData.create(:security_code => '^FCHI', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'EU', :security_name => 'CAC 40')
MarketData.create(:security_code => '^HSI', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AS', :security_name => '香港ハンセン')
MarketData.create(:security_code => '000001.SS', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AS', :security_name => '上海総合指数')
MarketData.create(:security_code => '^BSESN', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AS', :security_name => 'SENSEX30')
MarketData.create(:security_code => '^BVSP', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AM', :security_name => 'Bovespa')
MarketData.create(:security_code => '^AORD', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AS', :security_name => 'ASX')
MarketData.create(:security_code => '998407.O', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AS', :security_name => '日経平均株価')
MarketData.create(:security_code => '998405.T', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'IX', :region_code => 'AS', :security_name => 'TOPIX総合')

MarketData.create(:security_code => '^FVX', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'BD', :region_code => 'AM', :security_name => '米国債5年')
MarketData.create(:security_code => '^TNX', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'BD', :region_code => 'AM', :security_name => '米国債10年')
MarketData.create(:security_code => '^TYX', :vendor_code => '01', :market_code => 'DMY', :from_date => 20141221, :to_date => 99991231, :asset_class =>'BD', :region_code => 'AM', :security_name => '米国債30年')
