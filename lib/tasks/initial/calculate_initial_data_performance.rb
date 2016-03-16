#encoding: utf-8

require 'date'
include Performance

class Tasks::Calculate_Initial_Data_Performance
  def self.setup
 
    for num in 2..360 do
      # get reference date (format:YYYYMMDD)
      batchdate = (Date.today - num).strftime("%Y%m%d")
      weekday = batchdate.to_date.wday
      if (weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5) && batchdate.to_date.strftime("%m%d") != '0101'then  
        # Bolinger Band
        Technical_Indicator.calc_bolinger_band('USD/JPY', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('EUR/JPY', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('EUR/USD', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('GBP/JPY', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('GBP/USD', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('AUD/JPY', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('AUD/USD', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('NZD/JPY', 25, batchdate)
        Technical_Indicator.calc_bolinger_band('CAD/JPY', 25, batchdate)

        # Pivot
        Technical_Indicator.calc_daily_pivot('USD/JPY', batchdate)
        Technical_Indicator.calc_daily_pivot('EUR/JPY', batchdate)
        Technical_Indicator.calc_daily_pivot('EUR/USD', batchdate)
        Technical_Indicator.calc_daily_pivot('GBP/JPY', batchdate)
        Technical_Indicator.calc_daily_pivot('GBP/USD', batchdate)
        Technical_Indicator.calc_daily_pivot('AUD/JPY', batchdate)
        Technical_Indicator.calc_daily_pivot('AUD/USD', batchdate)
        Technical_Indicator.calc_daily_pivot('NZD/JPY', batchdate)
        Technical_Indicator.calc_daily_pivot('CAD/JPY', batchdate)
        
        # Difference from MA
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

        # RSI
        Technical_Indicator.calc_rsi('USD/JPY', 14, batchdate)
        Technical_Indicator.calc_rsi('EUR/JPY', 14, batchdate)
        Technical_Indicator.calc_rsi('EUR/USD', 14, batchdate)
        Technical_Indicator.calc_rsi('GBP/JPY', 14, batchdate)
        Technical_Indicator.calc_rsi('GBP/USD', 14, batchdate)
        Technical_Indicator.calc_rsi('AUD/JPY', 14, batchdate)
        Technical_Indicator.calc_rsi('AUD/USD', 14, batchdate)
        Technical_Indicator.calc_rsi('NZD/JPY', 14, batchdate)
        Technical_Indicator.calc_rsi('CAD/JPY', 14, batchdate)

        # Stochastics
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
  end
    
    
end
