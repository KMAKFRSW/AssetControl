#encoding: utf-8

require 'date'
include Performance

class Tasks::Calculate_Term_Risk
  def self.execute
    ##############################################################
    # calc following performance items :                         #
    #     prev_rate, range                                       #
    #     risk for n months(n = 1, 2, 3, 6, 12, 24, 36, 48, 60)  #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # get reference date (format:YYYYMMDD)
    batch_date = (Date.today - 1).strftime("%Y%m%d")
    
    # calculate term risk
    Performance.calc_term_risk('USD/JPY', batch_date)
    Performance.calc_term_risk('EUR/JPY', batch_date)
    Performance.calc_term_risk('EUR/USD', batch_date)
    Performance.calc_term_risk('GBP/JPY', batch_date)
    Performance.calc_term_risk('GBP/USD', batch_date)
    Performance.calc_term_risk('AUD/JPY', batch_date)
    Performance.calc_term_risk('AUD/USD', batch_date)
    Performance.calc_term_risk('NZD/JPY', batch_date)
    Performance.calc_term_risk('CAD/JPY', batch_date)
    
  end  
end


