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
    batchdate = (Date.today - 1).strftime("%Y%m%d")
    
    # calculate term risk
    Performance.calc_term_risk('USD/JPY', batchdate)
    Performance.calc_term_risk('EUR/JPY', batchdate)
    Performance.calc_term_risk('EUR/USD', batchdate)
    Performance.calc_term_risk('GBP/JPY', batchdate)
    Performance.calc_term_risk('GBP/USD', batchdate)
    Performance.calc_term_risk('AUD/JPY', batchdate)
    Performance.calc_term_risk('AUD/USD', batchdate)
    Performance.calc_term_risk('NZD/JPY', batchdate)
    Performance.calc_term_risk('CAD/JPY', batchdate)
    
  end  
end


