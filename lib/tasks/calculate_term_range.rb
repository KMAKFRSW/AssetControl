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

    ranges = FxRate.find_by_sql(["select trade_date, product_code2, ABS(high_price - low_price) as 'range' from fx_rates 
    where trade_date = ?
    and product_code2 IN ( ?, ?, ?, ?, ?, ?, ?)
    ", yesterday, 'USD/JPY', 'EUR/JPY','EUR/USD','AUD/JPY','GBP/JPY','AUD/USD','GBP/USD'])
    
    ranges.each do |row|
      # indicate digits
      if row.product_code2[4..6] = 'JPY'
        digits = "%.3f"
      else
        digits = "%.5f"
      end

      if FxPerformance.exists?({ :cur_code => row.product_code2, :calc_date => row.trade_date, :item => item_range })
          @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(row.product_code2, row.trade_date, item_range)
          @FxPerformance.attributes = {
              :data=> sprintf( digits, row.range)
          }
          @FxPerformance.save!
      else
        FxPerformance.create!(
            :cur_code  => row.product_code2,
            :calc_date => row.trade_date,
            :item      => item_range,
            :data      => sprintf( digits, row.range)
            )
      end
    end    
  end 
end