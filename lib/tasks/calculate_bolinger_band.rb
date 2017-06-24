#encoding: utf-8

require 'date'
include Technical_Indicator

class Tasks::Calculate_Bolinger_Band
  def self.execute
 
    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")    
    wrkweekday = yesterday.to_date.wday

    # if Sunday or Saturday, adjust to Friday
    case wrkweekday
    when 0 then
      batchdate = (yesterday.to_date - 2).strftime("%Y%m%d")
    when 6 then
      batchdate = (yesterday.to_date - 1).strftime("%Y%m%d")
    else
      batchdate = yesterday
    end

    Technical_Indicator.calc_bolinger_band('USD/JPY', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('EUR/JPY', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('EUR/USD', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('GBP/JPY', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('GBP/USD', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('AUD/JPY', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('AUD/USD', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('NZD/JPY', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('CAD/JPY', 25, batchdate)
    Technical_Indicator.calc_bolinger_band('TRY/JPY', 25, batchdate)
  end    
    
end
