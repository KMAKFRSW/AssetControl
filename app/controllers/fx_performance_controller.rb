#encoding: utf-8

class FxPerformanceController < ApplicationController
  def index
    
    # make instance for HV graph
    @usdjpy_term_risk_graph = term_risk_graph('USD/JPY','ドル円')
    @eurjpy_term_risk_graph = term_risk_graph('EUR/JPY','ユーロ円')
    @audjpy_term_risk_graph = term_risk_graph('AUD/JPY','豪ドル円')
    @gbpjpy_term_risk_graph = term_risk_graph('GBP/JPY','ポンド円')
    @eurusd_term_risk_graph = term_risk_graph('EUR/USD','ユーロドル')
    @audusd_term_risk_graph = term_risk_graph('AUD/USD','豪ドルドル')
    @gbpusd_term_risk_graph = term_risk_graph('GBP/USD','ポンドドル') 

    # make instance for range graph
    @usdjpy_avg_daily_range_graph = avg_daily_range_graph('USD/JPY','ドル円', 0, 10)
    @eurjpy_avg_daily_range_graph = avg_daily_range_graph('EUR/JPY','ユーロ円', 0, 10)
    @audjpy_avg_daily_range_graph = avg_daily_range_graph('AUD/JPY','豪ドル円', 0, 10)
    @gbpjpy_avg_daily_range_graph = avg_daily_range_graph('GBP/JPY','ポンド円', 0, 10)
    @eurusd_avg_daily_range_graph = avg_daily_range_graph('EUR/USD','ユーロドル', 0, 0.05)
    @audusd_avg_daily_range_graph = avg_daily_range_graph('AUD/USD','豪ドルドル', 0, 0.05)
    @gbpusd_avg_daily_range_graph = avg_daily_range_graph('GBP/USD','ポンドドル', 0, 0.05)

    # get daily pivot                                       
    @daily_pivot = FxPerformance.get_daily_pivot()

    # get daily pivot                                       
    @daily_technical_data = FxPerformance.get_technical_data()

  end

    def term_risk_graph(cur_code,cur_name)
     # define each item codes
      item_risk_1m    = Settings[:item_fx][:risk_1m]
      item_risk_3m    = Settings[:item_fx][:risk_3m]
      item_risk_6m    = Settings[:item_fx][:risk_6m]
      item_risk_12m   = Settings[:item_fx][:risk_12m]

      date          = Array.new
      term_risk_1m  = Array.new
      term_risk_3m  = Array.new
      term_risk_6m  = Array.new
      term_risk_12m = Array.new
    
      @term_risk = FxPerformance.get_term_risk(cur_code)
      
      wk_date = nil
      @term_risk.each do |term_risk|
        # if date is changed, store new date to array for date
        if wk_date != term_risk.date then
          date.push(term_risk.date)
        end
        # judging from item, store data to each array
        case term_risk.item
        when item_risk_1m then
          term_risk_1m.push(term_risk.data.to_f)
        when item_risk_3m then
          term_risk_3m.push(term_risk.data.to_f)
        when item_risk_6m then
          term_risk_6m.push(term_risk.data.to_f)
        end
        # restore wk_date
        wk_date = term_risk.date
      end
      
      @term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: cur_name + '：Historical Volatility チャート')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: date, tickInterval: 60)
        f.yAxis(:title => {:text => cur_code + 'Historical Volatility'}, :min => 0, :max => 30, tickInterval: 5)
        f.series(:type => 'line', name: 'Historical Volatility(1 month/20 day)'   , data: term_risk_1m  , pointFormat: 'Historical Volatility(1 month/20 day)')
        f.series(:type => 'line', name: 'Historical Volatility(3 month/60 day)'   , data: term_risk_3m  , pointFormat: 'Historical Volatility(3 month/60 day)')
        f.series(:type => 'line', name: 'Historical Volatility(6 month/120 day)'   , data: term_risk_6m  , pointFormat: 'Historical Volatility(6 month/120 day)')
      end
      
      return @term_risk_graph
      
    end
    
    def avg_daily_range_graph(cur_code,cur_name, min, max)
      # define each item codes
      item_range_5d_avg      = Settings[:item_fx][:range_5d_avg]
      item_range_25d_avg     = Settings[:item_fx][:range_25d_avg]
      item_range_75d_avg     = Settings[:item_fx][:range_75d_avg]
      item_range_100d_avg    = Settings[:item_fx][:range_100d_avg]
  
      # make array including the values to show chart of USD/JPY
      avg_date          = Array.new
      range_5d_avg      = Array.new
      range_25d_avg     = Array.new
      range_75d_avg     = Array.new
      range_100d_avg    = Array.new
      range_array       = Array.new
        
      @avg_range = FxPerformance.get_avg_daily_range(cur_code)
      @range = FxPerformance.get_daily_range(cur_code)
      
      @range.each do |range|
        range_array.push(range.data.to_f)
      end
      
      wk_date = nil

      @avg_range.each do |avg_range|
        # if date is changed, store new date to array for date
        if wk_date != avg_range.date then
          avg_date.push(avg_range.date)
        end
  
        # restore wk_date
        wk_date = avg_range.date        
        # judging from item, store data to each array
        case avg_range.item
        when item_range_5d_avg then
          range_5d_avg.push(avg_range.data.to_f)
        when item_range_25d_avg then
          range_25d_avg.push(avg_range.data.to_f)
        when item_range_75d_avg then
          range_75d_avg.push(avg_range.data.to_f)
        when item_range_100d_avg then
          range_100d_avg.push(avg_range.data.to_f)
        end
      end
      
      @avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: cur_name+'：値幅 チャート')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: avg_date, tickInterval: 60)
        f.yAxis(:title => {:text => cur_code+' 値幅'}, :min =>   min, :max =>   max, tickInterval: (max-min)/10 )
        f.series(:type => 'line', name: '値幅'        , data: range_array      , pointFormat: '値幅:')
        f.series(:type => 'line', name: '移動平均線(5 day)'   , data: range_5d_avg  , pointFormat: '移動平均線(5 day):')
        f.series(:type => 'line', name: '移動平均線(25 day)'   , data: range_25d_avg  , pointFormat: '移動平均線(25 day):')
        f.series(:type => 'line', name: '移動平均線(75 day)'   , data: range_75d_avg  , pointFormat: '移動平均線(75 day):')
  #      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: range_100d_avg  , pointFormat: '移動平均線(100 day):')
      end    
      
      return @avg_daily_range_graph
      
    end

end
