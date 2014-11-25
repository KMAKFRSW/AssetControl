#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/fx_rate"
require "#{Rails.root}/app/models/fx_performance"
include Calculation

class Tasks::Calculate_Term_Risk
  def self.execute
    ##############################################################
    # calc following performance items :                         #
    #     prev_rate, range                                       #
    #     risk for n months(n = 1, 2, 3, 6, 12, 24, 36, 48, 60)  #
    # scope of currency :                                        #
    #     'USD/JPY', 'EUR/JPY','EUR/USD'                         #
    ##############################################################

    # define each item codes
    item_risk_1m    = "RSK01"
    item_risk_2m    = "RSK02"
    item_risk_3m    = "RSK03"
    item_risk_6m    = "RSK06"
    item_risk_12m   = "RSK12"
    item_risk_24m   = "RSK24"
    item_risk_36m   = "RSK36"
    item_risk_48m   = "RSK48"
    item_risk_60m   = "RSK60"

    # get reference date (format:YYYYMMDD)
    yesterday = (Date.today - 1).strftime("%Y%m%d")
    
    ##############################################################
    # calc risk for n months(n = 1, 2, 3, 6, 12, 24, 36, 48, 60) #
    ##############################################################

    # make some arrays for each terms
    max_60m_return       = Array.new
    array_daily_return = Array.new

    # get max 60 months rates and store them into array sorting product_code2 and trade_date order
    max_60m_return = FxRate.find_by_sql(["select trade_date as calc_date, product_code2 as cur_code, ((close_price / prev_price -1)) as data from fx_rates 
    where trade_date between date_format( ? - INTERVAL 5 YEAR,'%Y%m%d') and ? 
    and product_code2 IN ( ?, ?, ?)
    order by cur_code asc, calc_date desc
    ", yesterday, yesterday, 'USD/JPY', 'EUR/JPY','EUR/USD'])

    
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
