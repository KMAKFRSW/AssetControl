#encoding: utf-8
include Calculation

module Performance
  
  def self.calc_term_range(cur_code, batchdate)
    ##################################################################################
    # calc following performance items :                                             #
    #     Daily Range                                                                #
    # scope of currency :                                                            #
    #     'USD/JPY', 'EUR/JPY','EUR/USD','AUD/JPY','GBP/JPY','AUD/USD','GBP/USD'     #
    ##################################################################################

    # define each item codes
    item_range    = Settings[:item_fx][:daily_range]

    # indicate digits
    if cur_code[4..6] == 'JPY'
      digits = "%.3f"
    else
      digits = "%.5f"
    end

    # calc range using reference date
    range = Array.new

    range = FxRate.find_by_sql(["select trade_date, product_code2, ABS(high_price - low_price) as 'range' from fx_rates 
    where trade_date = ?
    and product_code2 = ?
    ", batchdate, cur_code])
    
    unless range.empty? then
      if FxPerformance.exists?({ :cur_code => range.first.product_code2, :calc_date => range.first.trade_date, :item => item_range })
          @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(range.first.product_code2, range.first.trade_date, item_range)
          @FxPerformance.attributes = {
              :data=> sprintf( digits, range.first.range)
          }
          @FxPerformance.save!
      else
        FxPerformance.create!(
            :cur_code  => range.first.product_code2,
            :calc_date => range.first.trade_date,
            :item      => item_range,
            :data      => sprintf( digits, range.first.range)
            )
      end
    end
  end
  
  def calc_term_risk(cur_code, calc_date)

    # define each item codes
    item_risk_1m    = Settings[:item_fx][:risk_1m]
    item_risk_2m    = Settings[:item_fx][:risk_2m]
    item_risk_3m    = Settings[:item_fx][:risk_3m]
    item_risk_6m    = Settings[:item_fx][:risk_6m]
    item_risk_12m   = Settings[:item_fx][:risk_12m]
    item_risk_24m   = Settings[:item_fx][:risk_24m]
    item_risk_36m   = Settings[:item_fx][:risk_36m]
    item_risk_48m   = Settings[:item_fx][:risk_48m]
    item_risk_60m   = Settings[:item_fx][:risk_60m]
    
    # make some arrays for each terms
    max_60m_return     = Array.new
    array_daily_return = Array.new

    # get max 60 months rates and store them into array sorting product_code2 and trade_date order
    max_60m_return = FxRate.find_by_sql(["select trade_date as calc_date, product_code2 as cur_code, (((close_price / prev_price) -1) * 100) as data from fx_rates 
    where trade_date between date_format( ? - INTERVAL 5 YEAR,'%Y%m%d') and ? 
    and product_code2 = ?
    order by cur_code asc, calc_date desc
    ", calc_date, calc_date, cur_code])
    
    # initialize
    wk_cur_code = nil
    n = 0

    # calc risk for n months(n = 1, 2, 3, 6, 12, 24, 36, 48, 60)
    max_60m_return.each do |row|
      # repeat until getting other currency
      # store rates and increment 
      array_daily_return.push(row.data)
      n = n + 1
      # in case that n meet conditions, calculate term risk
      if n == 20 || n == 40 || n == 60 || n == 120 || n == 240 || n == 480 || n == 720 || n == 960 || n == 1200 then
        standard_deviation = StDev( array_daily_return, n)*Math::sqrt(250)
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
        if FxPerformance.exists?({ :cur_code => row.cur_code, :calc_date => calc_date, :item => item })
            @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(row.cur_code, calc_date, item )
            @FxPerformance.attributes = {
                :data => sprintf( "%.3f", standard_deviation.round(6))
            }
            @FxPerformance.save!
        else
          FxPerformance.create!(
              :cur_code  => row.cur_code,
              :calc_date => calc_date,
              :item      => item,
              :data      => sprintf( "%.3f", standard_deviation.round(6))
              )
        end
      end
    end
  end
  
  def calc_avg_range(cur_code, calc_date)

    # define each item codes
    item_avg_range_5d     = Settings[:item_fx][:range_5d_avg]
    item_avg_range_25d    = Settings[:item_fx][:range_25d_avg]
    item_avg_range_75d    = Settings[:item_fx][:range_75d_avg]
    item_avg_range_100d   = Settings[:item_fx][:range_100d_avg]

    # get reference date (format:YYYYMMDD)
    
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
      array_avg_range = FxPerformance.find_by_sql(["select X.cur_code, avg(X.data) as avg from (
        select product_code2 as cur_code , ABS(high_price - low_price) as data from fx_rates
        where trade_date <= ?
        and product_code2 = ?
        order by trade_date desc
        limit ?
        ) X
      ", calc_date, cur_code, term])
      
      unless array_avg_range.empty? then
        # in case that the value of array is not empty, accomodate data to database
        if FxPerformance.exists?({ :cur_code => cur_code, :calc_date => calc_date, :item => item_code })
            @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(cur_code, calc_date, item_code)
            @FxPerformance.attributes = {
                :data => array_avg_range.first.avg
            }
            @FxPerformance.save!
        else
          FxPerformance.create!(
              :cur_code  => cur_code,
              :calc_date => calc_date,
              :item      => item_code,
              :data      => array_avg_range.first.avg
              )
        end
      end        
    end
  end
  
  def calc_avg_rate(cur_code, calc_date)
    
    # define each item codes
    item_avg_rate_5d     = Settings[:item_fx][:rate_5d_avg]
    item_avg_rate_25d    = Settings[:item_fx][:rate_25d_avg]
    item_avg_rate_75d    = Settings[:item_fx][:rate_75d_avg]
    item_avg_rate_100d   = Settings[:item_fx][:rate_100d_avg]
    item_avg_rate_200d   = Settings[:item_fx][:rate_200d_avg]
    
    # define array for loop procedure
    arr_calc_target = [
      [5,item_avg_rate_5d],
      [25,item_avg_rate_25d],
      [75,item_avg_rate_75d],
      [100,item_avg_rate_100d],
      [200,item_avg_rate_200d]
    ]
          
    # declare some arrays for each terms
    array_avg_range = Array.new

    # calculate avg of daily range for past 5 day
    arr_calc_target.each do |term, item_code|
      
      array_avg_range = FxRate.find_by_sql(["select X.product_code2, avg(X.close_price) as avg from (
      select product_code2, close_price from fx_rates
      where trade_date <= ?
      and product_code2 = ?
      order by trade_date desc
      limit ?
      ) X
      ", calc_date, cur_code, term])
      
      unless array_avg_range.empty? then
        if FxPerformance.exists?({ :cur_code => cur_code, :calc_date => calc_date, :item => item_code })
            @FxPerformance = FxPerformance.find_by_cur_code_and_calc_date_and_item(cur_code, calc_date, item_code)
            @FxPerformance.attributes = {
                :data => array_avg_range.first.avg
            }
            @FxPerformance.save!
        else
          FxPerformance.create!(
              :cur_code  => cur_code,
              :calc_date => calc_date,
              :item      => item_code,
              :data      => array_avg_range.first.avg
              )
          end
      end
    end  
  end  
end