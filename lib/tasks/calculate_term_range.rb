#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/fx_rate"
require "#{Rails.root}/app/models/fx_performance"

class Tasks::Calculate_Term_Range
  def self.execute
    ##############################################################
    # calc following performance items :                         #
    #     Daily Range                                            #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_range    = Settings[:item_fx][:daily_range]

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")

    ##############################################################
    # calc range using reference date                            #
    ##############################################################
    ranges = Array.new

for num in 2..360 do
yesterday = (Date.today - num).strftime("%Y%m%d")
weekday = (Date.today - num).wday 
if weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 then

    ranges = FxRate.find_by_sql(["select trade_date, product_code2, format(round(high_price - low_price, 3),3) as 'range' from fx_rates 
    where trade_date = ?
    and product_code2 IN ( ?, ?, ?, ?, ?, ?, ?)
    ", yesterday, 'USD/JPY', 'EUR/JPY','EUR/USD','AUD/JPY','GBP/JPY','AUD/USD','GBP/USD'])
    
    ranges.each do |row|
      if FxPerformance.exists?({ :cur_code => row.product_code2, :calc_date => row.trade_date, :item => item_range })
          @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(row.product_code2, row.trade_date, item_range)
          @FxPerformance.attributes = {
              :data=> sprintf( "%.3f", row.range)
          }
          @FxPerformance.save!
      else
        FxPerformance.create!(
            :cur_code  => row.product_code2,
            :calc_date => row.trade_date,
            :item      => item_range,
            :data      => sprintf( "%.3f", row.range)
            )
      end
    end    
  end 
end
end
end