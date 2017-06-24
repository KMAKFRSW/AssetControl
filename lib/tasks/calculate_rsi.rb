#encoding: utf-8

require 'date'
include Technical_Indicator

class Tasks::Calculate_Rsi
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

    Technical_Indicator.calc_rsi('USD/JPY', 14, batchdate)
    Technical_Indicator.calc_rsi('EUR/JPY', 14, batchdate)
    Technical_Indicator.calc_rsi('EUR/USD', 14, batchdate)
    Technical_Indicator.calc_rsi('GBP/JPY', 14, batchdate)
    Technical_Indicator.calc_rsi('GBP/USD', 14, batchdate)
    Technical_Indicator.calc_rsi('AUD/JPY', 14, batchdate)
    Technical_Indicator.calc_rsi('AUD/USD', 14, batchdate)
    Technical_Indicator.calc_rsi('NZD/JPY', 14, batchdate)
    Technical_Indicator.calc_rsi('CAD/JPY', 14, batchdate)
    Technical_Indicator.calc_rsi('TRY/JPY', 14, batchdate)
  end  
end
