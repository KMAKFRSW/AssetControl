#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/fx_rate"
require "#{Rails.root}/app/models/fx_performance"
include Performance

class Tasks::Calculate_Term_Avg
  def self.calc_range_avg

    # get reference date (format:YYYYMMDD)
    batchdate = (Date.today - 1).strftime("%Y%m%d")
    
    # calculate average range for 5, 25, 75, 100 days
    Performance.calc_avg_range('USD/JPY', batchdate)
    Performance.calc_avg_range('EUR/JPY', batchdate)
    Performance.calc_avg_range('EUR/USD', batchdate)
    Performance.calc_avg_range('GBP/JPY', batchdate)
    Performance.calc_avg_range('GBP/USD', batchdate)
    Performance.calc_avg_range('AUD/JPY', batchdate)
    Performance.calc_avg_range('AUD/USD', batchdate)
    Performance.calc_avg_range('NZD/JPY', batchdate)
    Performance.calc_avg_range('CAD/JPY', batchdate)

  end
  
  def self.calc_rate_avg

    # get reference date (format:YYYYMMDD)
    batchdate = (Date.today - 1).strftime("%Y%m%d")
    
    # calculate term risk
    Performance.calc_avg_rate('USD/JPY', batchdate)
    Performance.calc_avg_rate('EUR/JPY', batchdate)
    Performance.calc_avg_rate('EUR/USD', batchdate)
    Performance.calc_avg_rate('GBP/JPY', batchdate)
    Performance.calc_avg_rate('GBP/USD', batchdate)
    Performance.calc_avg_rate('AUD/JPY', batchdate)
    Performance.calc_avg_rate('AUD/USD', batchdate)
    Performance.calc_avg_rate('NZD/JPY', batchdate)
    Performance.calc_avg_rate('CAD/JPY', batchdate)

  end
end

