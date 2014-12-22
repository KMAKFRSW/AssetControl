#encoding: utf-8

class Universe
  def self.get_universe(asset_class, region_code)
    # declare variable and cons
    array_mkt_attr = Array.new
    
    # decide data_date(YYYYMMDD) by region_code
    case region_code
    when 'AS'
      data_date = (Date.today ).strftime("%Y%m%d")
    when 'EU', 'AM'
      data_date = (Date.today - 1).strftime("%Y%m%d")
    end
  
    # get the kinds of target market data
    array_mkt_attr = MarketData.find_by_sql(["select security_code, vendor_code, security_name, asset_class, region_code, market_code from market_data
    where ? between from_date and to_date
    and asset_class = ?
    and region_code = ?
    order by region_code, asset_class
    ", data_date, asset_class, region_code,])
    
    # return universe
    return array_mkt_attr, data_date
    
  end
end
