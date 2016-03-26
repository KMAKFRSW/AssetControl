#encoding: utf-8

class FxPerformanceController < ApplicationController
  def index
    # get technical data
    @daily_pivot = FxPerformance.get_daily_pivot()
    @daily_bolinger_band = FxPerformance.get_bolinger_band()
    
    # make instance for HV graph
    @usdjpy_term_risk_graph = term_risk_graph('USD/JPY','ドル円')
    @eurjpy_term_risk_graph = term_risk_graph('EUR/JPY','ユーロ円')
    @audjpy_term_risk_graph = term_risk_graph('AUD/JPY','豪ドル円')
    @gbpjpy_term_risk_graph = term_risk_graph('GBP/JPY','ポンド円')
    @eurusd_term_risk_graph = term_risk_graph('EUR/USD','ユーロドル')
    @audusd_term_risk_graph = term_risk_graph('AUD/USD','豪ドルドル')
    @gbpusd_term_risk_graph = term_risk_graph('GBP/USD','ポンドドル') 

    # make instance for range graph
    @usdjpy_avg_daily_range_graph = avg_daily_range_graph('USD/JPY','ドル円')
    @eurjpy_avg_daily_range_graph = avg_daily_range_graph('EUR/JPY','ユーロ円')
    @audjpy_avg_daily_range_graph = avg_daily_range_graph('AUD/JPY','豪ドル円')
    @gbpjpy_avg_daily_range_graph = avg_daily_range_graph('GBP/JPY','ポンド円')
    @eurusd_avg_daily_range_graph = avg_daily_range_graph('EUR/USD','ユーロドル')
    @audusd_avg_daily_range_graph = avg_daily_range_graph('AUD/USD','豪ドルドル')
    @gbpusd_avg_daily_range_graph = avg_daily_range_graph('GBP/USD','ポンドドル')
    
     # make instance for dfma graph
    @usdjpy_dfma_graph = dfma_graph('USD/JPY','ドル円')
    @eurjpy_dfma_graph = dfma_graph('EUR/JPY','ユーロ円')
    @audjpy_dfma_graph = dfma_graph('AUD/JPY','豪ドル円')
    @gbpjpy_dfma_graph = dfma_graph('GBP/JPY','ポンド円')
    @eurusd_dfma_graph = dfma_graph('EUR/USD','ユーロドル')
    @audusd_dfma_graph = dfma_graph('AUD/USD','豪ドルドル')
    @gbpusd_dfma_graph = dfma_graph('GBP/USD','ポンドドル') 

     # make instance for rsi_and_st graph
    @usdjpy_rsi_and_st_graph = rsi_and_st_graph('USD/JPY','ドル円')
    @eurjpy_rsi_and_st_graph = rsi_and_st_graph('EUR/JPY','ユーロ円')
    @audjpy_rsi_and_st_graph = rsi_and_st_graph('AUD/JPY','豪ドル円')
    @gbpjpy_rsi_and_st_graph = rsi_and_st_graph('GBP/JPY','ポンド円')
    @eurusd_rsi_and_st_graph = rsi_and_st_graph('EUR/USD','ユーロドル')
    @audusd_rsi_and_st_graph = rsi_and_st_graph('AUD/USD','豪ドルドル')
    @gbpusd_rsi_and_st_graph = rsi_and_st_graph('GBP/USD','ポンドドル') 

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
        f.xAxis(categories: date, tickInterval: 90)
        f.yAxis(:title => {:text => cur_code + 'Historical Volatility'}, :min => 0, :max => 30, tickInterval: 5)
        f.series(:type => 'line', name: 'Historical Volatility(1 month/20 day)'   , data: term_risk_1m  , pointFormat: 'Historical Volatility(1 month/20 day)')
        f.series(:type => 'line', name: 'Historical Volatility(3 month/60 day)'   , data: term_risk_3m  , pointFormat: 'Historical Volatility(3 month/60 day)')
        f.series(:type => 'line', name: 'Historical Volatility(6 month/120 day)'   , data: term_risk_6m  , pointFormat: 'Historical Volatility(6 month/120 day)')
      end
      
      return @term_risk_graph
      
    end
    
    def avg_daily_range_graph(cur_code,cur_name)
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

    if cur_code[4..6] == 'JPY'
      max = range_array.max.round(0)
      min = range_array.min.round(0)
      interval = (max-min)/10
    else
      max = range_array.max.round(3)
      min = range_array.min.round(3)
      interval = (max-min)/10
    end
      
      @avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: cur_name+'：値幅 チャート')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: avg_date, tickInterval: 90)
        f.yAxis(:title => {:text => cur_code+' 値幅'}, :min =>   min, :max =>   max, tickInterval: interval )
        f.series(:type => 'line', name: '値幅'        , data: range_array      , pointFormat: '値幅:')
        f.series(:type => 'line', name: '移動平均線(5 day)'   , data: range_5d_avg  , pointFormat: '移動平均線(5 day):')
        f.series(:type => 'line', name: '移動平均線(25 day)'   , data: range_25d_avg  , pointFormat: '移動平均線(25 day):')
  #      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: range_75d_avg  , pointFormat: '移動平均線(75 day):')
  #      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: range_100d_avg  , pointFormat: '移動平均線(100 day):')
      end    
      
      return @avg_daily_range_graph
      
    end

    def dfma_graph(cur_code,cur_name)
      date     = Array.new
      dfma_5d  = Array.new
      dfma_25d = Array.new
    
      @dfma = FxPerformance.get_dfma(cur_code)
      
      @dfma.each do |dfma|
        date.push(dfma.date)
        dfma_5d.push(dfma.DFMA5.to_f)
        dfma_25d.push(dfma.DFMA25.to_f)
      end
      
      @dfma_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: cur_name + '：移動平均乖離率 チャート')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: date, tickInterval: 90)
        f.yAxis(:title => {:text => cur_code + '移動平均乖離率'}, :min => -7.5, :max => 7.5, tickInterval: 2.5)
        f.series(:type => 'line', name: '移動平均乖離率(5 day)'   , data: dfma_5d  , pointFormat: '移動平均乖離率(5 day)')
        f.series(:type => 'line', name: '移動平均乖離率(25 day)'   , data: dfma_25d  , pointFormat: '移動平均乖離率(25 day)')
      end
      
      return @dfma_graph
      
    end

    def rsi_and_st_graph(cur_code,cur_name)
      date     = Array.new
      rsi_and_st_rsi  = Array.new
      rsi_and_st_k = Array.new
      rsi_and_st_d = Array.new
    
      @rsi_and_st = FxPerformance.get_rsi_and_st(cur_code)
      
      @rsi_and_st.each do |rsi_and_st|
        date.push(rsi_and_st.date)
        rsi_and_st_rsi.push(rsi_and_st.RSI.to_f)
        rsi_and_st_k.push(rsi_and_st.K.to_f)
        rsi_and_st_d.push(rsi_and_st.D.to_f)
      end
      
      @rsi_and_st_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: cur_name + '：RSI & Stochastic チャート')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: date, tickInterval: 90)
        f.yAxis(:title => {:text => cur_code + 'RSI & Stochastic'}, :min => 0, :max => 100, tickInterval: 10)
        f.series(:type => 'line', name: 'RSI'   , data: rsi_and_st_rsi  , pointFormat: 'RSI')
        f.series(:type => 'line', name: 'Stochastic(%K)'   , data: rsi_and_st_k  , pointFormat: 'Stochastic(%K)')
        f.series(:type => 'line', name: 'Stochastic(%D)'   , data: rsi_and_st_d  , pointFormat: 'Stochastic(%D)')
      end
      
      return @rsi_and_st_graph
      
    end


end
