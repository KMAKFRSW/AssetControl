#encoding: utf-8

require 'date'
include Technical_Indicator

class Tasks::Calculate_Difference_From_Ma
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
    
    Technical_Indicator.calc_difference_from_ma('USD/JPY', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('EUR/JPY', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('EUR/USD', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('GBP/JPY', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('GBP/USD', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('AUD/JPY', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('AUD/USD', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('NZD/JPY', batchdate, 5)
    Technical_Indicator.calc_difference_from_ma('CAD/JPY', batchdate, 5)

    Technical_Indicator.calc_difference_from_ma('USD/JPY', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('EUR/JPY', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('EUR/USD', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('GBP/JPY', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('GBP/USD', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('AUD/JPY', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('AUD/USD', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('NZD/JPY', batchdate, 25)
    Technical_Indicator.calc_difference_from_ma('CAD/JPY', batchdate, 25)
    
  end  
end
