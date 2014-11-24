#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/fx_rate"
require "#{Rails.root}/app/models/fx_performance"

class Tasks::Calculate_Term_Return
  def self.execute
    ##############################################################
    # calc following performance items :                         #
    #     Daily Return                                           #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_daily_return    = "RTN01"

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")
    
    for day in 1..360 do
    yesterday = (Date.today - day).strftime("%Y%m%d")


    ##############################################################
    # calc return(%) using reference date                        #
    ##############################################################
    prev_rates = Array.new
    prev_rates = FxRate.find_by_sql(["select trade_date, product_code2, round((close_price / prev_price -1) * 100, 3) as 'prev_rate' from fx_rates 
    where trade_date = ?
    and product_code2 IN ( ?, ?, ?)
    ", yesterday, 'USD/JPY', 'EUR/JPY','EUR/USD'])
    
    prev_rates.each do |row|
      if FxPerformance.exists?({ :cur_code => row.product_code2, :calc_date => row.trade_date, :item => item_daily_return })
          @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(row.product_code2, row.trade_date, item_daily_return)
          @FxPerformance.attributes = {
              :data => sprintf( "%.3f", row.prev_rate)
          }
          @FxPerformance.save!
      else
        FxPerformance.create!(
            :cur_code  => row.product_code2,
            :calc_date => row.trade_date,
            :item      => item_daily_return,
            :data      => sprintf( "%.3f", row.prev_rate)
            )
      end
    end    
  end 
  end 
end
