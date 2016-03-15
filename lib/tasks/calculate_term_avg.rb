#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/fx_rate"
require "#{Rails.root}/app/models/fx_performance"
include Performance

class Tasks::Calculate_Term_Avg
  def self.calc_range_avg

    # get reference date (format:YYYYMMDD)
    batch_date = (Date.today - 1).strftime("%Y%m%d")
    
    # calculate term risk
    Performance.calc_avg_range('USD/JPY', batch_date)
    Performance.calc_avg_range('EUR/JPY', batch_date)
    Performance.calc_avg_range('EUR/USD', batch_date)
    Performance.calc_avg_range('GBP/JPY', batch_date)
    Performance.calc_avg_range('GBP/USD', batch_date)
    Performance.calc_avg_range('AUD/JPY', batch_date)
    Performance.calc_avg_range('AUD/USD', batch_date)
    Performance.calc_avg_range('NZD/JPY', batch_date)
    Performance.calc_avg_range('CAD/JPY', batch_date)

  end
  
  def self.calc_rate_avg

    # get reference date (format:YYYYMMDD)
    batch_date = (Date.today - 1).strftime("%Y%m%d")
    
    # calculate term risk
    Performance.calc_avg_rate('USD/JPY', batch_date)
    Performance.calc_avg_rate('EUR/JPY', batch_date)
    Performance.calc_avg_rate('EUR/USD', batch_date)
    Performance.calc_avg_rate('GBP/JPY', batch_date)
    Performance.calc_avg_rate('GBP/USD', batch_date)
    Performance.calc_avg_rate('AUD/JPY', batch_date)
    Performance.calc_avg_rate('AUD/USD', batch_date)
    Performance.calc_avg_rate('NZD/JPY', batch_date)
    Performance.calc_avg_rate('CAD/JPY', batch_date)

  end
end

