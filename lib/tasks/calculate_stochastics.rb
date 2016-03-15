#encoding: utf-8

require 'date'
include Technical_Indicator

class Tasks::Calculate_Stochastics
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
    end
    
    Technical_Indicator.calc_stochastics('USD/JPY', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('EUR/JPY', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('EUR/USD', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('GBP/JPY', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('GBP/USD', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('AUD/JPY', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('AUD/USD', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('NZD/JPY', batchdate, 14, 3)
    Technical_Indicator.calc_stochastics('CAD/JPY', batchdate, 14, 3)
  end  
end
