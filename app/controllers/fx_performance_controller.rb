#encoding: utf-8

class FxPerformanceController < ApplicationController
  def index
    ########################################################
    # get daily rate for USD/JPY, EUR/JPY, EUR/USD        # 
    ########################################################
    @usdjpy_term_risk, @eurjpy_term_risk, @eurusd_term_risk , @audjpy_term_risk, @audusd_term_risk , @gbpjpy_term_risk, @gbpusd_term_risk = FxPerformance.get_term_risk()
    
    ###################################################################
    # get average of daily range for USD/JPY, EUR/JPY, EUR/USD        # 
    ###################################################################
    @usdjpy_avg_range, @eurjpy_avg_range, @eurusd_avg_range, @audjpy_avg_range, @audusd_avg_range, @gbpjpy_avg_range, @gbpusd_avg_range = FxPerformance.get_avg_daily_range()

    ########################################################
    # get daily range for USD/JPY, EUR/JPY, EUR/USD        # 
    ########################################################
    @usdjpy_range, @eurjpy_range, @eurusd_range, @audjpy_range, @audusd_range, @gbpjpy_range, @gbpusd_range = FxPerformance.get_daily_range()
    
    ##########################################################################
    # variable for histrical volatility chart of USD/JPY, EUR/JPY, EUR/USD   #
    ##########################################################################
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

    wk_date = nil

    # make array including the values to show chart of USD/JPY
    usdjpy_date          = Array.new
    usdjpy_term_risk_1m  = Array.new
    usdjpy_term_risk_3m  = Array.new
    usdjpy_term_risk_6m  = Array.new
    usdjpy_term_risk_12m = Array.new
    
    @usdjpy_term_risk.each do |usdjpy_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != usdjpy_term_risk.date then
        usdjpy_date.push(usdjpy_term_risk.date)
      end
      # restore wk_date
      wk_date = usdjpy_term_risk.date        
      # judging from item, store data to each array
      case usdjpy_term_risk.item
      when item_risk_1m then
        usdjpy_term_risk_1m.push(usdjpy_term_risk.data.to_f)
      when item_risk_3m then
        usdjpy_term_risk_3m.push(usdjpy_term_risk.data.to_f)
      when item_risk_6m then
        usdjpy_term_risk_6m.push(usdjpy_term_risk.data.to_f)
      end
    end
    
    @usdjpy_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'USD/JPY Historical Volatility'}, :min => 0, :max => 25, tickInterval: 5)
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: usdjpy_term_risk_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: usdjpy_term_risk_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: usdjpy_term_risk_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f} % </b>')
    end

    # make array including the values to show chart of EUR/JPY
    eurjpy_date          = Array.new
    eurjpy_term_risk_1m  = Array.new
    eurjpy_term_risk_3m  = Array.new
    eurjpy_term_risk_6m  = Array.new
    eurjpy_term_risk_12m = Array.new
    
    @eurjpy_term_risk.each do |eurjpy_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != eurjpy_term_risk.date then
        eurjpy_date.push(eurjpy_term_risk.date)
      end
      # restore wk_date
      wk_date = eurjpy_term_risk.date        
      # judging from item, store data to each array
      case eurjpy_term_risk.item
      when item_risk_1m then
        eurjpy_term_risk_1m.push(eurjpy_term_risk.data.to_f)
      when item_risk_3m then
        eurjpy_term_risk_3m.push(eurjpy_term_risk.data.to_f)
      when item_risk_6m then
        eurjpy_term_risk_6m.push(eurjpy_term_risk.data.to_f)
      end
    end
    
    @eurjpy_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロ円：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: eurjpy_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'EUR/JPY Historical Volatility'}, :min => 0, :max => 25, tickInterval: 5)
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: eurjpy_term_risk_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: eurjpy_term_risk_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: eurjpy_term_risk_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f} % </b>')
    end
    
    # make array including the values to show chart of USD/EUR
    eurusd_date          = Array.new
    eurusd_term_risk_1m  = Array.new
    eurusd_term_risk_3m  = Array.new
    eurusd_term_risk_6m  = Array.new
    eurusd_term_risk_12m = Array.new
    
    @eurusd_term_risk.each do |eurusd_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != eurusd_term_risk.date then
        eurusd_date.push(eurusd_term_risk.date)
      end
      # restore wk_date
      wk_date = eurusd_term_risk.date        
      # judging from item, store data to each array
      case eurusd_term_risk.item
      when item_risk_1m then
        eurusd_term_risk_1m.push(eurusd_term_risk.data.to_f)
      when item_risk_3m then
        eurusd_term_risk_3m.push(eurusd_term_risk.data.to_f)
      when item_risk_6m then
        eurusd_term_risk_6m.push(eurusd_term_risk.data.to_f)
      end
    end
    
    @eurusd_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロドル：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: eurusd_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'USD/EUR Historical Volatility'}, :min => 0, :max => 20, tickInterval: 10 )
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: eurusd_term_risk_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: eurusd_term_risk_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: eurusd_term_risk_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f} % </b>')
    end

    # make array including the values to show chart of AUD/JPY
    audjpy_date          = Array.new
    audjpy_term_risk_1m  = Array.new
    audjpy_term_risk_3m  = Array.new
    audjpy_term_risk_6m  = Array.new
    audjpy_term_risk_12m = Array.new
    
    @audjpy_term_risk.each do |audjpy_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != audjpy_term_risk.date then
        audjpy_date.push(audjpy_term_risk.date)
      end
      # restore wk_date
      wk_date = audjpy_term_risk.date        
      # judging from item, store data to each array
      case audjpy_term_risk.item
      when item_risk_1m then
        audjpy_term_risk_1m.push(audjpy_term_risk.data.to_f)
      when item_risk_3m then
        audjpy_term_risk_3m.push(audjpy_term_risk.data.to_f)
      when item_risk_6m then
        audjpy_term_risk_6m.push(audjpy_term_risk.data.to_f)
      end
    end
    
    @audjpy_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '豪ドル円：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: audjpy_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'AUD/JPY Historical Volatility'}, :min => 0, :max => 25, tickInterval: 5)
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: audjpy_term_risk_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: audjpy_term_risk_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: audjpy_term_risk_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f} % </b>')
    end
    
    # make array including the values to show chart of USD/aud
    audusd_date          = Array.new
    audusd_term_risk_1m  = Array.new
    audusd_term_risk_3m  = Array.new
    audusd_term_risk_6m  = Array.new
    audusd_term_risk_12m = Array.new
    
    @audusd_term_risk.each do |audusd_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != audusd_term_risk.date then
        audusd_date.push(audusd_term_risk.date)
      end
      # restore wk_date
      wk_date = audusd_term_risk.date        
      # judging from item, store data to each array
      case audusd_term_risk.item
      when item_risk_1m then
        audusd_term_risk_1m.push(audusd_term_risk.data.to_f)
      when item_risk_3m then
        audusd_term_risk_3m.push(audusd_term_risk.data.to_f)
      when item_risk_6m then
        audusd_term_risk_6m.push(audusd_term_risk.data.to_f)
      end
    end
    
    @audusd_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '豪ドルドル：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: audusd_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'AUD/USD Historical Volatility'}, :min => 0, :max => 25, tickInterval: 5)
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: audusd_term_risk_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: audusd_term_risk_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: audusd_term_risk_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f} % </b>')
    end
    # make array including the values to show chart of GBP/JPY
    gbpjpy_date          = Array.new
    gbpjpy_term_risk_1m  = Array.new
    gbpjpy_term_risk_3m  = Array.new
    gbpjpy_term_risk_6m  = Array.new
    gbpjpy_term_risk_12m = Array.new
    
    @gbpjpy_term_risk.each do |gbpjpy_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != gbpjpy_term_risk.date then
        gbpjpy_date.push(gbpjpy_term_risk.date)
      end
      # restore wk_date
      wk_date = gbpjpy_term_risk.date        
      # judging from item, store data to each array
      case gbpjpy_term_risk.item
      when item_risk_1m then
        gbpjpy_term_risk_1m.push(gbpjpy_term_risk.data.to_f)
      when item_risk_3m then
        gbpjpy_term_risk_3m.push(gbpjpy_term_risk.data.to_f)
      when item_risk_6m then
        gbpjpy_term_risk_6m.push(gbpjpy_term_risk.data.to_f)
      end
    end
    
    @gbpjpy_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ポンド円：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: gbpjpy_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'GBP/JPY Historical Volatility'}, :min => 0, :max => 25, tickInterval: 5)
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: gbpjpy_term_risk_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: gbpjpy_term_risk_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: gbpjpy_term_risk_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f} % </b>')
    end
    
    # make array including the values to show chart of USD/gbp
    gbpusd_date          = Array.new
    gbpusd_term_risk_1m  = Array.new
    gbpusd_term_risk_3m  = Array.new
    gbpusd_term_risk_6m  = Array.new
    gbpusd_term_risk_12m = Array.new
    
    @gbpusd_term_risk.each do |gbpusd_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != gbpusd_term_risk.date then
        gbpusd_date.push(gbpusd_term_risk.date)
      end
      # restore wk_date
      wk_date = gbpusd_term_risk.date        
      # judging from item, store data to each array
      case gbpusd_term_risk.item
      when item_risk_1m then
        gbpusd_term_risk_1m.push(gbpusd_term_risk.data.to_f)
      when item_risk_3m then
        gbpusd_term_risk_3m.push(gbpusd_term_risk.data.to_f)
      when item_risk_6m then
        gbpusd_term_risk_6m.push(gbpusd_term_risk.data.to_f)
      end
    end
    
    @gbpusd_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ポンドドル：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: gbpusd_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'GBP/USD Historical Volatility'}, :min => 0, :max => 25, tickInterval: 5)
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: gbpusd_term_risk_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: gbpusd_term_risk_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: gbpusd_term_risk_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f} % </b>')
    end

    ##########################################################################
    # variable for average of daily range chart of USD/JPY, EUR/JPY, EUR/USD #
    ##########################################################################
    # define each item codes
    item_range_5d_avg      = Settings[:item_fx][:range_5d_avg]
    item_range_25d_avg     = Settings[:item_fx][:range_25d_avg]
    item_range_75d_avg     = Settings[:item_fx][:range_75d_avg]
    item_range_100d_avg    = Settings[:item_fx][:range_100d_avg]

    # make array including the values to show chart of USD/JPY
    usdjpy_avg_date          = Array.new
    usdjpy_range_5d_avg      = Array.new
    usdjpy_range_25d_avg     = Array.new
    usdjpy_range_75d_avg     = Array.new
    usdjpy_range_100d_avg    = Array.new
    usdjpy_range_array       = Array.new
    
    @usdjpy_range.each do |usdjpy_range|
      usdjpy_range_array.push(usdjpy_range.data.to_f)
    end
    
    @usdjpy_avg_range.each do |usdjpy_avg_range|
      # if date is changed, store new date to array for date
      if wk_date != usdjpy_avg_range.date then
        usdjpy_avg_date.push(usdjpy_avg_range.date)
      end

      # restore wk_date
      wk_date = usdjpy_avg_range.date        
      # judging from item, store data to each array
      case usdjpy_avg_range.item
      when item_range_5d_avg then
        usdjpy_range_5d_avg.push(usdjpy_avg_range.data.to_f)
      when item_range_25d_avg then
        usdjpy_range_25d_avg.push(usdjpy_avg_range.data.to_f)
      when item_range_75d_avg then
        usdjpy_range_75d_avg.push(usdjpy_avg_range.data.to_f)
      when item_range_100d_avg then
        usdjpy_range_100d_avg.push(usdjpy_avg_range.data.to_f)
      end
    end
    
    @usdjpy_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'USD/JPY 値幅'}, :min =>   0, :max =>   5, tickInterval: 1 )
      f.series(:type => 'line', name: '値幅'        , data: usdjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} 円</b>')
      f.series(:type => 'line', name: '移動平均線(5 day)'   , data: usdjpy_range_5d_avg  , pointFormat: '移動平均線(5 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(25 day)'   , data: usdjpy_range_25d_avg  , pointFormat: '移動平均線(25 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: usdjpy_range_75d_avg  , pointFormat: '移動平均線(75 day): <b>{point.y:.3f} % </b>')
#      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: usdjpy_range_100d_avg  , pointFormat: '移動平均線(100 day): <b>{point.y:.3f} % </b>')
    end

    # make array including the values to show chart of USD/JPY
    eurjpy_avg_date          = Array.new
    eurjpy_range_5d_avg      = Array.new
    eurjpy_range_25d_avg     = Array.new
    eurjpy_range_75d_avg     = Array.new
    eurjpy_range_100d_avg    = Array.new
    eurjpy_range_array       = Array.new
    
    @eurjpy_range.each do |eurjpy_range|
      eurjpy_range_array.push(eurjpy_range.data.to_f)
    end
    
    @eurjpy_avg_range.each do |eurjpy_avg_range|
      # if date is changed, store new date to array for date
      if wk_date != eurjpy_avg_range.date then
        eurjpy_avg_date.push(eurjpy_avg_range.date)
      end

      # restore wk_date
      wk_date = eurjpy_avg_range.date        
      # judging from item, store data to each array
      case eurjpy_avg_range.item
      when item_range_5d_avg then
        eurjpy_range_5d_avg.push(eurjpy_avg_range.data.to_f)
      when item_range_25d_avg then
        eurjpy_range_25d_avg.push(eurjpy_avg_range.data.to_f)
      when item_range_75d_avg then
        eurjpy_range_75d_avg.push(eurjpy_avg_range.data.to_f)
      when item_range_100d_avg then
        eurjpy_range_100d_avg.push(eurjpy_avg_range.data.to_f)
      end
    end
    
    @eurjpy_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロ円：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: eurjpy_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'EUR/JPY 値幅'}, :min =>   0, :max =>   5, tickInterval: 1 )
      f.series(:type => 'line', name: '値幅'        , data: eurjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} 円</b>')
      f.series(:type => 'line', name: '移動平均線(5 day)'   , data: eurjpy_range_5d_avg  , pointFormat: '移動平均線(5 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(25 day)'   , data: eurjpy_range_25d_avg  , pointFormat: '移動平均線(25 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: eurjpy_range_75d_avg  , pointFormat: '移動平均線(75 day): <b>{point.y:.3f} % </b>')
#      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: eurjpy_range_100d_avg  , pointFormat: '移動平均線(100 day): <b>{point.y:.3f} % </b>')
    end
    # make array including the values to show chart of USD/JPY
    eurusd_avg_date          = Array.new
    eurusd_range_5d_avg      = Array.new
    eurusd_range_25d_avg     = Array.new
    eurusd_range_75d_avg     = Array.new
    eurusd_range_100d_avg    = Array.new
    eurusd_range_array       = Array.new
    
    @eurusd_range.each do |eurusd_range|
      eurusd_range_array.push(eurusd_range.data.to_f)
    end

    @eurusd_avg_range.each do |eurusd_avg_range|
      # if date is changed, store new date to array for date
      if wk_date != eurusd_avg_range.date then
        eurusd_avg_date.push(eurusd_avg_range.date)
      end

      # restore wk_date
      wk_date = eurusd_avg_range.date        
      # judging from item, store data to each array
      case eurusd_avg_range.item
      when item_range_5d_avg then
        eurusd_range_5d_avg.push(eurusd_avg_range.data.to_f)
      when item_range_25d_avg then
        eurusd_range_25d_avg.push(eurusd_avg_range.data.to_f)
      when item_range_75d_avg then
        eurusd_range_75d_avg.push(eurusd_avg_range.data.to_f)
      when item_range_100d_avg then
        eurusd_range_100d_avg.push(eurusd_avg_range.data.to_f)
      end
    end
    
    @eurusd_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロドル：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: eurusd_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'EUR/USD 値幅'}, :min =>   0, :max => 0.05, tickInterval: 0.01 )
      f.series(:type => 'line', name: '値幅'        , data: eurusd_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: '移動平均線(5 day)'   , data: eurusd_range_5d_avg  , pointFormat: '移動平均線(5 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(25 day)'   , data: eurusd_range_25d_avg  , pointFormat: '移動平均線(25 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: eurusd_range_75d_avg  , pointFormat: '移動平均線(75 day): <b>{point.y:.3f} % </b>')
#      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: eurusd_range_100d_avg  , pointFormat: '移動平均線(100 day): <b>{point.y:.3f} % </b>')
    end

    # make array including the values to show chart of USD/JPY
    audjpy_avg_date          = Array.new
    audjpy_range_5d_avg      = Array.new
    audjpy_range_25d_avg     = Array.new
    audjpy_range_75d_avg     = Array.new
    audjpy_range_100d_avg    = Array.new
    audjpy_range_array       = Array.new
    
    @audjpy_range.each do |audjpy_range|
      audjpy_range_array.push(audjpy_range.data.to_f)
    end
    
    @audjpy_avg_range.each do |audjpy_avg_range|
      # if date is changed, store new date to array for date
      if wk_date != audjpy_avg_range.date then
        audjpy_avg_date.push(audjpy_avg_range.date)
      end

      # restore wk_date
      wk_date = audjpy_avg_range.date        
      # judging from item, store data to each array
      case audjpy_avg_range.item
      when item_range_5d_avg then
        audjpy_range_5d_avg.push(audjpy_avg_range.data.to_f)
      when item_range_25d_avg then
        audjpy_range_25d_avg.push(audjpy_avg_range.data.to_f)
      when item_range_75d_avg then
        audjpy_range_75d_avg.push(audjpy_avg_range.data.to_f)
      when item_range_100d_avg then
        audjpy_range_100d_avg.push(audjpy_avg_range.data.to_f)
      end
    end
    
    @audjpy_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '豪ドル円：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: audjpy_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'AUD/JPY 値幅'}, :min =>   0, :max =>   5, tickInterval: 1 )
      f.series(:type => 'line', name: '値幅'        , data: audjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} 円</b>')
      f.series(:type => 'line', name: '移動平均線(5 day)'   , data: audjpy_range_5d_avg  , pointFormat: '移動平均線(5 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(25 day)'   , data: audjpy_range_25d_avg  , pointFormat: '移動平均線(25 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: audjpy_range_75d_avg  , pointFormat: '移動平均線(75 day): <b>{point.y:.3f} % </b>')
#      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: audjpy_range_100d_avg  , pointFormat: '移動平均線(100 day): <b>{point.y:.3f} % </b>')
    end
    # make array including the values to show chart of USD/JPY
    audusd_avg_date          = Array.new
    audusd_range_5d_avg      = Array.new
    audusd_range_25d_avg     = Array.new
    audusd_range_75d_avg     = Array.new
    audusd_range_100d_avg    = Array.new
    audusd_range_array       = Array.new
    
    @audusd_range.each do |audusd_range|
      audusd_range_array.push(audusd_range.data.to_f)
    end

    @audusd_avg_range.each do |audusd_avg_range|
      # if date is changed, store new date to array for date
      if wk_date != audusd_avg_range.date then
        audusd_avg_date.push(audusd_avg_range.date)
      end

      # restore wk_date
      wk_date = audusd_avg_range.date        
      # judging from item, store data to each array
      case audusd_avg_range.item
      when item_range_5d_avg then
        audusd_range_5d_avg.push(audusd_avg_range.data.to_f)
      when item_range_25d_avg then
        audusd_range_25d_avg.push(audusd_avg_range.data.to_f)
      when item_range_75d_avg then
        audusd_range_75d_avg.push(audusd_avg_range.data.to_f)
      when item_range_100d_avg then
        audusd_range_100d_avg.push(audusd_avg_range.data.to_f)
      end
    end
    
    @audusd_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '豪ドルドル：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: audusd_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'AUD/USD 値幅'}, :min =>   0, :max => 0.05, tickInterval: 0.01 )
      f.series(:type => 'line', name: '値幅'        , data: audusd_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: '移動平均線(5 day)'   , data: audusd_range_5d_avg  , pointFormat: '移動平均線(5 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(25 day)'   , data: audusd_range_25d_avg  , pointFormat: '移動平均線(25 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: audusd_range_75d_avg  , pointFormat: '移動平均線(75 day): <b>{point.y:.3f} % </b>')
#      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: audusd_range_100d_avg  , pointFormat: '移動平均線(100 day): <b>{point.y:.3f} % </b>')
    end

    # make array including the values to show chart of USD/JPY
    gbpjpy_avg_date          = Array.new
    gbpjpy_range_5d_avg      = Array.new
    gbpjpy_range_25d_avg     = Array.new
    gbpjpy_range_75d_avg     = Array.new
    gbpjpy_range_100d_avg    = Array.new
    gbpjpy_range_array       = Array.new
    
    @gbpjpy_range.each do |gbpjpy_range|
      gbpjpy_range_array.push(gbpjpy_range.data.to_f)
    end
    
    @gbpjpy_avg_range.each do |gbpjpy_avg_range|
      # if date is changed, store new date to array for date
      if wk_date != gbpjpy_avg_range.date then
        gbpjpy_avg_date.push(gbpjpy_avg_range.date)
      end

      # restore wk_date
      wk_date = gbpjpy_avg_range.date        
      # judging from item, store data to each array
      case gbpjpy_avg_range.item
      when item_range_5d_avg then
        gbpjpy_range_5d_avg.push(gbpjpy_avg_range.data.to_f)
      when item_range_25d_avg then
        gbpjpy_range_25d_avg.push(gbpjpy_avg_range.data.to_f)
      when item_range_75d_avg then
        gbpjpy_range_75d_avg.push(gbpjpy_avg_range.data.to_f)
      when item_range_100d_avg then
        gbpjpy_range_100d_avg.push(gbpjpy_avg_range.data.to_f)
      end
    end
    
    @gbpjpy_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ポンド円：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: gbpjpy_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'GBP/JPY 値幅'}, :min =>   0, :max =>   5, tickInterval: 1 )
      f.series(:type => 'line', name: '値幅'        , data: gbpjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} 円</b>')
      f.series(:type => 'line', name: '移動平均線(5 day)'   , data: gbpjpy_range_5d_avg  , pointFormat: '移動平均線(5 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(25 day)'   , data: gbpjpy_range_25d_avg  , pointFormat: '移動平均線(25 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: gbpjpy_range_75d_avg  , pointFormat: '移動平均線(75 day): <b>{point.y:.3f} % </b>')
#      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: gbpjpy_range_100d_avg  , pointFormat: '移動平均線(100 day): <b>{point.y:.3f} % </b>')
    end
    # make array including the values to show chart of USD/JPY
    gbpusd_avg_date          = Array.new
    gbpusd_range_5d_avg      = Array.new
    gbpusd_range_25d_avg     = Array.new
    gbpusd_range_75d_avg     = Array.new
    gbpusd_range_100d_avg    = Array.new
    gbpusd_range_array       = Array.new
    
    @gbpusd_range.each do |gbpusd_range|
      gbpusd_range_array.push(gbpusd_range.data.to_f)
    end

    @gbpusd_avg_range.each do |gbpusd_avg_range|
      # if date is changed, store new date to array for date
      if wk_date != gbpusd_avg_range.date then
        gbpusd_avg_date.push(gbpusd_avg_range.date)
      end

      # restore wk_date
      wk_date = gbpusd_avg_range.date        
      # judging from item, store data to each array
      case gbpusd_avg_range.item
      when item_range_5d_avg then
        gbpusd_range_5d_avg.push(gbpusd_avg_range.data.to_f)
      when item_range_25d_avg then
        gbpusd_range_25d_avg.push(gbpusd_avg_range.data.to_f)
      when item_range_75d_avg then
        gbpusd_range_75d_avg.push(gbpusd_avg_range.data.to_f)
      when item_range_100d_avg then
        gbpusd_range_100d_avg.push(gbpusd_avg_range.data.to_f)
      end
    end
    
    @gbpusd_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ポンドドル：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: gbpusd_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => 'GBP/USD 値幅'}, :min =>   0, :max => 0.05, tickInterval: 0.01 )
      f.series(:type => 'line', name: '値幅'        , data: gbpusd_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: '移動平均線(5 day)'   , data: gbpusd_range_5d_avg  , pointFormat: '移動平均線(5 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(25 day)'   , data: gbpusd_range_25d_avg  , pointFormat: '移動平均線(25 day): <b>{point.y:.3f} % </b>')
      f.series(:type => 'line', name: '移動平均線(75 day)'   , data: gbpusd_range_75d_avg  , pointFormat: '移動平均線(75 day): <b>{point.y:.3f} % </b>')
#      f.series(:type => 'line', name: '移動平均線(100 day)'   , data: gbpusd_range_100d_avg  , pointFormat: '移動平均線(100 day): <b>{point.y:.3f} % </b>')
    end



# test graph
    @allcurjpy_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '全通貨：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => '全通貨（クロス円） 値幅'}, :min =>   0, :max => 5, tickInterval: 0.5 )
      f.series(:type => 'line', name: 'USD/JPY'        , data: usdjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: 'EUR/JPY'        , data: eurjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: 'AUD/JPY'        , data: audjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: 'GBP/JPY'        , data: gbpjpy_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
    end

    @allcurusd_avg_daily_range_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '全通貨：値幅 チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_avg_date, tickInterval: 60)
      f.yAxis(:title => {:text => '全通貨（ドルストレート） 値幅'}, :min =>   0, :max => 0.1, tickInterval: 0.02 )
      f.series(:type => 'line', name: 'EUR/USD'        , data: eurusd_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: 'AUD/USD'        , data: audusd_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
      f.series(:type => 'line', name: 'GBP/USD'        , data: gbpusd_range_array      , pointFormat: '値幅:         <b>{point.y:.3f} ＄</b>')
    end


  end
end
