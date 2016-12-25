#encoding: utf-8

require 'date'
include Performance

class Tasks::Calculate_Term_Range
  def self.execute
    # get reference date (format:YYYYMMDD)
    batchdate = (Date.today - 1).strftime("%Y%m%d")
    
    # calculate term range
    Performance.calc_term_range('USD/JPY', batchdate)
    Performance.calc_term_range('EUR/JPY', batchdate)
    Performance.calc_term_range('EUR/USD', batchdate)
    Performance.calc_term_range('GBP/JPY', batchdate)
    Performance.calc_term_range('GBP/USD', batchdate)
    Performance.calc_term_range('AUD/JPY', batchdate)
    Performance.calc_term_range('AUD/USD', batchdate)
    Performance.calc_term_range('NZD/JPY', batchdate)
    Performance.calc_term_range('CAD/JPY', batchdate)
    
    Performance.calc_daily_atr('USD/JPY', batchdate)
    Performance.calc_daily_atr('EUR/JPY', batchdate)
    Performance.calc_daily_atr('EUR/USD', batchdate)
    Performance.calc_daily_atr('GBP/JPY', batchdate)
    Performance.calc_daily_atr('GBP/USD', batchdate)
    Performance.calc_daily_atr('AUD/JPY', batchdate)
    Performance.calc_daily_atr('AUD/USD', batchdate)
    Performance.calc_daily_atr('NZD/JPY', batchdate)
    Performance.calc_daily_atr('CAD/JPY', batchdate)
    
  end

end