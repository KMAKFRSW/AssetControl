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
  end

end