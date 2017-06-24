#encoding: utf-8

require 'date'
include Technical_Indicator
include Performance

class Tasks::Calculate_Initial_Data
  def self.setup_technical

   (Date.parse('2015-04-01')..Date.parse('2017-06-23')).each do |date|
      # get reference date (format:YYYYMMDD)
      batchdate = date.strftime("%Y%m%d")
      weekday = batchdate.to_date.wday
      if (weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5) && batchdate.to_date.strftime("%m%d") != '0101'then  
        # Bolinger Band
        Technical_Indicator.calc_bolinger_band('TRY/JPY', 25, batchdate)

        # Pivot
        Technical_Indicator.calc_daily_pivot('TRY/JPY', batchdate)
        
        # Difference from MA
        Technical_Indicator.calc_difference_from_ma('TRY/JPY', batchdate, 5)
    
        Technical_Indicator.calc_difference_from_ma('TRY/JPY', batchdate, 25)

        Technical_Indicator.calc_difference_from_ma('TRY/JPY', batchdate, 100)


        # RSI
        Technical_Indicator.calc_rsi('TRY/JPY', 14, batchdate)

        # Stochastics
        Technical_Indicator.calc_stochastics('TRY/JPY', batchdate, 14, 3)
        
      end
    end
  end

  def self.setup_performance
    # delete all data
    #FxPerformance.destroy_all("item = 'RNG01'")
    #FxPerformance.destroy_all("item like 'AVG%'")

   (Date.parse('2013-04-01')..Date.parse('2017-06-23')).each do |date|
      # get reference date (format:YYYYMMDD)
      batchdate = date.strftime("%Y%m%d")
      weekday = batchdate.to_date.wday
      if (weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5) && batchdate.to_date.strftime("%m%d") != '0101'then  

        # calculate daily atr
        Performance.calc_daily_atr('TRY/JPY', batchdate)        

      end
    end

   (Date.parse('2015-04-01')..Date.parse('2017-06-23')).each do |date|

      # get reference date (format:YYYYMMDD)
      batchdate = date.strftime("%Y%m%d")
      weekday = batchdate.to_date.wday
      if (weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5) && batchdate.to_date.strftime("%m%d") != '0101'then  

        # calculate term range
        Performance.calc_term_range('TRY/JPY', batchdate)
            
        # calculate average range for 5, 25, 75, 100 days
        Performance.calc_avg_range('TRY/JPY', batchdate)

        # calculate term risk
        Performance.calc_avg_rate('TRY/JPY', batchdate)

        # calculate term risk
        Performance.calc_term_risk('TRY/JPY', batchdate)

      end    
        
    end
  end
end
