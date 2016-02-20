#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/fx_rate"
require "#{Rails.root}/app/models/fx_performance"
include Calculation

class Tasks::Calculate_InitialData
  def self.execute
    ##############################################################
    # calc following performance items :                         #
    #     average of daily range for each terms                  #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_avg_range_5d     = Settings[:item][:range_5d_avg]
    item_avg_range_25d    = Settings[:item][:range_25d_avg]
    item_avg_range_75d    = Settings[:item][:range_75d_avg]
    item_avg_range_100d   = Settings[:item][:range_100d_avg]

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")

    for num in 2..360 do
      yesterday = (Date.today - num).strftime("%Y%m%d")
      weekday = (Date.today - num).wday 
      if weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 then
        
        # define array for loop procedure
        arr_calc_target = [
          [5,item_avg_range_5d],
          [25,item_avg_range_25d],
          [75,item_avg_range_75d],
          [100,item_avg_range_100d]
        ]
              
        # declare some arrays for each terms
        array_avg_range = Array.new
    
        # calculate avg of daily range for past 5 day
        arr_calc_target.each do |term, item_code|
          array_avg_range = FxPerformance.find_by_sql(["select cur_code, round(avg(data), 3) as avg from fx_performances
          where calc_date between date_format( ? - INTERVAL ? DAY,'%Y%m%d')  and ?
          and cur_code IN ( ?, ?, ?, ?, ?, ?, ?)
          and item = 'RNG01'
          group by cur_code
          order by cur_code asc
          ", yesterday, term, yesterday,'USD/JPY','EUR/JPY','EUR/USD','AUD/JPY','ADU/USD','GBP/JPY','GBP/USD'])
          
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
  
    ##############################################################
    # calc following performance items :                         #
    #     Daily Range                                            #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_range    = Settings[:item][:daily_range]

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")

    for num in 2..360 do
      yesterday = (Date.today - num).strftime("%Y%m%d")
      weekday = (Date.today - num).wday 
      if weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 then
        
        ##############################################################
        # calc range using reference date                            #
        ##############################################################
        ranges = Array.new
        ranges = FxRate.find_by_sql(["select trade_date, product_code2, format(round(high_price - low_price, 3),3) as 'range' from fx_rates 
        where trade_date = ?
        and product_code2 IN ( ?, ?, ?, ?, ?, ?, ?)
        ", yesterday, 'USD/JPY','EUR/JPY','EUR/USD','AUD/JPY','ADU/USD','GBP/JPY','GBP/USD'])
        
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
  
    ##############################################################
    # calc following performance items :                         #
    #     Daily Return                                           #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_daily_return    = Settings[:item][:daily_return]

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")

    for num in 2..360 do
      yesterday = (Date.today - num).strftime("%Y%m%d")
      weekday = (Date.today - num).wday 
      if weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 then
      
        ##############################################################
        # calc return(%) using reference date                        #
        ##############################################################
        prev_rates = Array.new
        prev_rates = FxRate.find_by_sql(["select trade_date, product_code2, round((close_price / prev_price -1) , 3) as 'prev_rate' from fx_rates 
        where trade_date = ?
        and product_code2 IN ( ?, ?, ?, ?, ?, ?, ?)
        ", yesterday,'USD/JPY','EUR/JPY','EUR/USD','AUD/JPY','ADU/USD','GBP/JPY','GBP/USD'])
        
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

    ##############################################################
    # calc following performance items :                         #
    #     prev_rate, range                                       #
    #     risk for n months(n = 1, 2, 3, 6, 12, 24, 36, 48, 60)  #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_risk_1m    = Settings[:item][:risk_1m]
    item_risk_2m    = Settings[:item][:risk_2m]
    item_risk_3m    = Settings[:item][:risk_3m]
    item_risk_6m    = Settings[:item][:risk_6m]
    item_risk_12m   = Settings[:item][:risk_12m]
    item_risk_24m   = Settings[:item][:risk_24m]
    item_risk_36m   = Settings[:item][:risk_36m]
    item_risk_48m   = Settings[:item][:risk_48m]
    item_risk_60m   = Settings[:item][:risk_60m]

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")

    for num in 2..360 do
      yesterday = (Date.today - num).strftime("%Y%m%d")
      weekday = (Date.today - num).wday 
      if weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5 then
           
        ##############################################################
        # calc risk for n months(n = 1, 2, 3, 6, 12, 24, 36, 48, 60) #
        ##############################################################
    
        # make some arrays for each terms
        max_60m_return       = Array.new
        array_daily_return = Array.new
    
        # get max 60 months rates and store them into array sorting product_code2 and trade_date order
        max_60m_return = FxRate.find_by_sql(["select trade_date as calc_date, product_code2 as cur_code, (((close_price / prev_price) -1) * 100) as data from fx_rates 
        where trade_date between date_format( ? - INTERVAL 5 YEAR,'%Y%m%d') and ? 
        and product_code2 IN ( ?, ?, ?)
        order by cur_code asc, calc_date desc
        ", yesterday, yesterday, 'USD/JPY','EUR/JPY','EUR/USD','AUD/JPY','ADU/USD','GBP/JPY','GBP/USD'])
        
        # initialize
        wk_cur_code = nil
        n = 0
    
        # calc risk for n months(n = 1, 2, 3, 6, 12, 24, 36, 48, 60)
        max_60m_return.each do |row|
          # repeat until getting other currency
          if row.cur_code == wk_cur_code then
            # store rates and increment 
            array_daily_return.push(row.data)
            n = n + 1
            # in case that n meet conditions, calculate term risk
            if n == 20 || n == 40 || n == 60 || n == 120 || n == 240 || n == 480 || n == 720 || n == 960 || n == 1200 then
              standard_deviation = CalcTermRisk( array_daily_return, n)
              case n
              when 20 then
                item = item_risk_1m
              when 40 then
                item = item_risk_2m
              when 60 then
                item = item_risk_3m
              when 120 then
                item = item_risk_6m
              when 240 then
                item = item_risk_12m
              when 480 then
                item = item_risk_24m
              when 720 then
                item = item_risk_36m
              when 960 then
                item = item_risk_48m
              when 1200 then
                item = item_risk_60m
              end
              # DB update
              if FxPerformance.exists?({ :cur_code => row.cur_code, :calc_date => yesterday, :item => item })
                  @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(row.cur_code, yesterday, item )
                  @FxPerformance.attributes = {
                      :data => sprintf( "%.3f", standard_deviation.round(6))
                  }
                  @FxPerformance.save!
              else
                FxPerformance.create!(
                    :cur_code  => row.cur_code,
                    :calc_date => yesterday,
                    :item      => item,
                    :data      => sprintf( "%.3f", standard_deviation.round(6))
                    )
              end
            end
          else
            # if currency_code is not same , reset array and counter
            array_daily_return = []
            n = 0          
            # store rates and increment 
            array_daily_return.push(row.data)
            n = n + 1
          end
          # change the value of matching key
          wk_cur_code = row.cur_code
        end        
      end
    end
  end
end
