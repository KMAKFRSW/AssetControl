#encoding: utf-8

class MarketDataPrice < ActiveRecord::Base
  attr_accessible :data, :item, :market_code, :security_code, :trade_date, :vendor_code
  self.table_name = 'market_data_prices'
  self.primary_keys = :trade_date, :market_code, :security_code, :vendor_code, :item

end
