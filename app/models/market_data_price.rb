class MarketDataPrice < ActiveRecord::Base
  attr_accessible :data, :item, :market_code, :security_code, :trade_date, :vendor_code
end
