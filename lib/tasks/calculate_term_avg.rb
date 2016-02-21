#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/fx_rate"
require "#{Rails.root}/app/models/fx_performance"

class Tasks::Calculate_Term_Avg
  def self.calc_range_avg
    ##############################################################
    # calc following performance items :                         #
    #     average of daily range for each terms                  #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_avg_range_5d     = Settings[:item_fx][:range_5d_avg]
    item_avg_range_25d    = Settings[:item_fx][:range_25d_avg]
    item_avg_range_75d    = Settings[:item_fx][:range_75d_avg]
    item_avg_range_100d   = Settings[:item_fx][:range_100d_avg]

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")
    
    # define array for loop procedure
    arr_calc_target = [
      [5,item_avg_range_5d],
      [25,item_avg_range_25d],
      [75,item_avg_range_75d],
      [100,item_avg_range_100d]
    ]
          
    # declare some arrays for each terms
    array_avg_range = Array.new
    
for num in 2..360 do
yesterday = (Date.today - num).strftime("%Y%m%d")
weekday = (Date.today - num).wday 
if weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 then

    # calculate avg of daily range for past 5 day
    arr_calc_target.each do |term, item_code|
      array_avg_range = FxPerformance.find_by_sql(["select cur_code, round(avg(data), 3) as avg from fx_performances
      where calc_date between date_format( ? - INTERVAL ? DAY,'%Y%m%d')  and ?
      and cur_code IN ( ?, ?, ?, ?, ?, ?, ?)
      and item = 'RNG01'
      group by cur_code
      order by cur_code asc
      ", yesterday, term, yesterday,'USD/JPY','EUR/JPY','EUR/USD','AUD/JPY','GBP/JPY','AUD/USD','GBP/USD'])
      
      array_avg_range.each do |row|
        if FxPerformance.exists?({ :cur_code => row.cur_code, :calc_date => yesterday, :item => item_code })
            @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(row.cur_code, yesterday, item_code)
            @FxPerformance.attributes = {
                :data => row.avg
            }
            @FxPerformance.save!
        else
          FxPerformance.create!(
              :cur_code  => row.cur_code,
              :calc_date => yesterday,
              :item      => item_code,
              :data      => row.avg
              )
        end
      end
    end
  end
  end
  end
  
  def self.calc_rate_avg
    ##############################################################
    # calc following performance items :                         #
    #     average of daily range for each terms                  #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_avg_rate_5d     = Settings[:item_fx][:rate_5d_avg]
    item_avg_rate_25d    = Settings[:item_fx][:rate_25d_avg]
    item_avg_rate_75d    = Settings[:item_fx][:rate_75d_avg]
    item_avg_rate_100d   = Settings[:item_fx][:rate_100d_avg]

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")
    
    # define array for loop procedure
    arr_calc_target = [
      [5,item_avg_rate_5d],
      [25,item_avg_rate_25d],
      [75,item_avg_rate_75d],
      [100,item_avg_rate_100d]
    ]
          
    # declare some arrays for each terms
    array_avg_range = Array.new

for num in 2..360 do
yesterday = (Date.today - num).strftime("%Y%m%d")
weekday = (Date.today - num).wday 
if weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 then

    # calculate avg of daily range for past 5 day
    arr_calc_target.each do |term, item_code|
      array_avg_range = FxRate.find_by_sql(["select product_code2, round(avg(close_price), 3) as avg from fx_rates
      where trade_date between date_format( ? - INTERVAL ? DAY,'%Y%m%d')  and ?
      and product_code2 IN ( ?, ?, ?, ?, ?, ?, ?)
      group by product_code2
      order by product_code2 asc
      ", yesterday, term, yesterday,'USD/JPY','EUR/JPY','EUR/USD','AUD/JPY','GBP/JPY','AUD/USD','GBP/USD'])
      
      array_avg_range.each do |row|
        if FxPerformance.exists?({ :cur_code => row.product_code2, :calc_date => yesterday, :item => item_code })
            @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(row.product_code2, yesterday, item_code)
            @FxPerformance.attributes = {
                :data => row.avg
            }
            @FxPerformance.save!
        else
          FxPerformance.create!(
              :cur_code  => row.product_code2,
              :calc_date => yesterday,
              :item      => item_code,
              :data      => row.avg
              )
        end
      end
    end
  end
  end
  end
end

