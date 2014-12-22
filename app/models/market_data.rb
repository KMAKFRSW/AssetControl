class MarketData < ActiveRecord::Base
  attr_accessible :asset_class, :from_date, :market_code, :region_code, :security_code, :to_date, :vendor_code, :security_name
end
