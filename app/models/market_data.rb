#encoding: utf-8

class MarketData < ActiveRecord::Base
  attr_accessible :asset_class, :from_date, :market_code, :region_code, :security_code, :to_date, :vendor_code, :security_name
  self.table_name = 'market_data'
  self.primary_keys = :from_date, :market_code, :security_code, :vendor_code
end
