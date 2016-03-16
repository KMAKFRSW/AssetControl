#encoding: utf-8

require 'date'
include Technical_Indicator

class Tasks::Calculate_Daily_Pivot
  def self.execute
 
    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")    
    wrkweekday = yesterday.to_date.wday
    case wrkweekday
    # if Sunday or Saturday, adjust to Friday
    when 0 then
      batchdate = (yesterday.to_date - 2).strftime("%Y%m%d")
    when 6 then
      batchdate = (yesterday.to_date - 1).strftime("%Y%m%d")
    else
      batchdate = yesterday      
    end

    Technical_Indicator.calc_daily_pivot('USD/JPY', batchdate)
    Technical_Indicator.calc_daily_pivot('EUR/JPY', batchdate)
    Technical_Indicator.calc_daily_pivot('EUR/USD', batchdate)
    Technical_Indicator.calc_daily_pivot('GBP/JPY', batchdate)
    Technical_Indicator.calc_daily_pivot('GBP/USD', batchdate)
    Technical_Indicator.calc_daily_pivot('AUD/JPY', batchdate)
    Technical_Indicator.calc_daily_pivot('AUD/USD', batchdate)
    Technical_Indicator.calc_daily_pivot('NZD/JPY', batchdate)
    Technical_Indicator.calc_daily_pivot('CAD/JPY', batchdate)
  end  
end
