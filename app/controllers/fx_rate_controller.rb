#encoding: utf-8

class FxRateController < ApplicationController
  def index
    ########################################################
    # get recent rates of each currencies                  #
    ########################################################
    @latest_rate = FxRate.get_latest_rate()

    ########################################################
    # get daily rate for USD/JPY, EUR/JPY, EUR/USD        # 
    ########################################################
    @usdjpy_2year, @eurjpy_2year, @eurusd_2year = FxRate.get_daily_rate()
    
    ##########################################################################
    # make array for average of daily rate chart of USD/JPY, EUR/JPY, EUR/USD #
    ##########################################################################
    # define each item codes
    item_rate_5d_avg      = Settings[:item_fx][:rate_5d_avg]
    item_rate_25d_avg     = Settings[:item_fx][:rate_25d_avg]
    item_rate_75d_avg     = Settings[:item_fx][:rate_75d_avg]
    item_rate_100d_avg    = Settings[:item_fx][:rate_100d_avg]
 
    # get avg of daily rate
    @usdjpy_avg_rate, @eurjpy_avg_rate, @eurusd_avg_rate = FxPerformance.get_avg_daily_rate()

    # make array including the values to show chart of USD/JPY
    usdjpy_avg_rate_5d_avg      = Array.new
    usdjpy_avg_rate_25d_avg     = Array.new
    usdjpy_avg_rate_75d_avg     = Array.new
    usdjpy_avg_rate_100d_avg    = Array.new
    usdjpy_avg_rate_array       = Array.new
        
    @usdjpy_avg_rate.each do |usdjpy_avg_rate|
      # judging from item, store data to each array
      case usdjpy_avg_rate.item
      when item_rate_5d_avg then
        usdjpy_avg_rate_5d_avg.push(usdjpy_avg_rate.data.to_f)
      when item_rate_25d_avg then
        usdjpy_avg_rate_25d_avg.push(usdjpy_avg_rate.data.to_f)
      when item_rate_75d_avg then
        usdjpy_avg_rate_75d_avg.push(usdjpy_avg_rate.data.to_f)
      when item_rate_100d_avg then
        usdjpy_avg_rate_100d_avg.push(usdjpy_avg_rate.data.to_f)
      end
    end
    
    # make array including the values to show chart of USD/JPY
    eurjpy_avg_rate_5d_avg      = Array.new
    eurjpy_avg_rate_25d_avg     = Array.new
    eurjpy_avg_rate_75d_avg     = Array.new
    eurjpy_avg_rate_100d_avg    = Array.new
    eurjpy_avg_rate_array       = Array.new
    
    @eurjpy_avg_rate.each do |eurjpy_avg_rate|
      # judging from item, store data to each array
      case eurjpy_avg_rate.item
      when item_rate_5d_avg then
        eurjpy_avg_rate_5d_avg.push(eurjpy_avg_rate.data.to_f)
      when item_rate_25d_avg then
        eurjpy_avg_rate_25d_avg.push(eurjpy_avg_rate.data.to_f)
      when item_rate_75d_avg then
        eurjpy_avg_rate_75d_avg.push(eurjpy_avg_rate.data.to_f)
      when item_rate_100d_avg then
        eurjpy_avg_rate_100d_avg.push(eurjpy_avg_rate.data.to_f)
      end
    end
    
    # make array including the values to show chart of USD/JPY
    eurusd_avg_rate_5d_avg      = Array.new
    eurusd_avg_rate_25d_avg     = Array.new
    eurusd_avg_rate_75d_avg     = Array.new
    eurusd_avg_rate_100d_avg    = Array.new
    eurusd_avg_rate_array       = Array.new
    
    @eurusd_avg_rate.each do |eurusd_avg_rate|
      # judging from item, store data to each array
      case eurusd_avg_rate.item
      when item_rate_5d_avg then
        eurusd_avg_rate_5d_avg.push(eurusd_avg_rate.data.to_f)
      when item_rate_25d_avg then
        eurusd_avg_rate_25d_avg.push(eurusd_avg_rate.data.to_f)
      when item_rate_75d_avg then
        eurusd_avg_rate_75d_avg.push(eurusd_avg_rate.data.to_f)
      when item_rate_100d_avg then
        eurusd_avg_rate_100d_avg.push(eurusd_avg_rate.data.to_f)
      end
    end

    ########################################################
    # declare variable for chart of USD/JPY                #
    ########################################################
    # make array including the values to show chart of USD/JPY
    usdjpy_trade_date_array        = Array.new
    usdjpy_low_price_array         = Array.new
    usdjpy_high_price_array        = Array.new
    usdjpy_close_price_array       = Array.new
    usdjpy_position_quantity_array = Array.new
    usdjpy_trade_quantity_array    = Array.new

    @usdjpy_2year.each do |usdjpy_2year|
      usdjpy_trade_date_array.push(usdjpy_2year.date)
      usdjpy_low_price_array.push(usdjpy_2year.low_price.to_f)
      usdjpy_high_price_array.push(usdjpy_2year.high_price.to_f)
      usdjpy_close_price_array.push(usdjpy_2year.close_price.to_f)
      usdjpy_position_quantity_array.push(usdjpy_2year.position_quantity.to_i)
      usdjpy_trade_quantity_array.push(usdjpy_2year.trade_quantity.to_i)
    end
    
    @usdjpy_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円:FXチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_trade_date_array, tickInterval: 60)
      f.yAxis [
        {:title => {:text => 'USD/JPY'}, :min => 80, :max => 125, tickInterval: 5 , format: '{value} 円'},
      ]
#      f.series(:yAxis => 0, :type => 'line', name: 'Low Pirce'  , data: usdjpy_low_price_array  , pointFormat: 'Low Price:   <b>{point.y:.3f} 円</b>')
#      f.series(:yAxis => 0, :type => 'line', name: 'High Pirce' , data: usdjpy_high_price_array , pointFormat: 'High Price:  <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'Close Pirce', data: usdjpy_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(25 day)'  , data: usdjpy_avg_rate_25d_avg  , pointFormat: '移動平均線(25 day):   <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(75 day)'  , data: usdjpy_avg_rate_75d_avg  , pointFormat: '移動平均線(75 day):   <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(100 day)'  , data: usdjpy_avg_rate_100d_avg  , pointFormat: '移動平均線(100 day):   <b>{point.y:.3f} 円</b>')
    end
    @usdjpy_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円:FXポシションチャート')
      f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_trade_date_array, tickInterval: 60) 
      f.yAxis [
       {:title => {:text => 'USD/JPY 建玉量'}, labels: {tickInterval: 100000, format: '{value} 枚'}},
       {:title => {:text => 'USD/JPY 取引量'}, labels: {tickInterval: 10000 , format: '{value} 枚'} , opposite: true}
      ]
      f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: usdjpy_position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
      f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: usdjpy_trade_quantity_array   , pointFormat: '取引数量: <b>{point.y} 枚</b>')
    end
    
  ########################################################
  # variable for chart of EUR/JPY                        #
  ########################################################
    eurjpy_trade_date_array = Array.new
    eurjpy_low_price_array = Array.new
    eurjpy_high_price_array = Array.new
    eurjpy_close_price_array = Array.new
    eurjpy_position_quantity_array = Array.new
    eurjpy_trade_quantity_array = Array.new
    
    @eurjpy_2year.each do |eurjpy_2year|
      eurjpy_trade_date_array.push(eurjpy_2year.date)
      eurjpy_low_price_array.push(eurjpy_2year.low_price.to_f)
      eurjpy_high_price_array.push(eurjpy_2year.high_price.to_f)
      eurjpy_close_price_array.push(eurjpy_2year.close_price.to_f)
      eurjpy_position_quantity_array.push(eurjpy_2year.position_quantity.to_i)
      eurjpy_trade_quantity_array.push(eurjpy_2year.trade_quantity.to_i)
    end

    @eurjpy_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロ円:FXチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories:eurjpy_trade_date_array, tickInterval: 60)
      f.yAxis [
        {:title => {:text => 'EUR/JPY'}, :min => 95, :max => 150, tickInterval: 5 , format: '{value} 円'},
      ]
#      f.series(:yAxis => 0, :type => 'line', name: 'Low Pirce'  , data: eurjpy_low_price_array  , pointFormat: 'Low Price:   <b>{point.y:.3f} 円</b>')
#      f.series(:yAxis => 0, :type => 'line', name: 'High Pirce' , data: eurjpy_high_price_array , pointFormat: 'High Price:  <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'Close Pirce', data: eurjpy_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(25 day)'  , data: eurjpy_avg_rate_25d_avg  , pointFormat: '移動平均線(25 day):   <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(75 day)'  , data: eurjpy_avg_rate_75d_avg  , pointFormat: '移動平均線(75 day):   <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(100 day)'  , data: eurjpy_avg_rate_100d_avg  , pointFormat: '移動平均線(100 day):   <b>{point.y:.3f} 円</b>')
    end
    @eurjpy_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロ円:FXポシションチャート')
      f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
      f.xAxis(categories: eurjpy_trade_date_array, tickInterval: 60) 
      f.yAxis [
       {:title => {:text => 'EUR/JPY 建玉量'}, labels: {tickInterval: 1000, format: '{value} 枚'}},
       {:title => {:text => 'EUR/JPY 取引量'}, labels: {tickInterval: 1000, format: '{value} 枚'}, opposite: true}, 
      ]
      f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: eurjpy_position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
      f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: eurjpy_trade_quantity_array, pointFormat: '取引数量: <b>{point.y} 枚</b>')
    end

  ########################################################
  # variable for chart of EUR/USD                        #
  ########################################################
    eurusd_trade_date_array = Array.new
    eurusd_low_price_array = Array.new
    eurusd_high_price_array = Array.new
    eurusd_close_price_array = Array.new
    eurusd_position_quantity_array = Array.new
    eurusd_trade_quantity_array = Array.new
    
    @eurusd_2year.each do |eurusd_2year|
      eurusd_trade_date_array.push(eurusd_2year.date)
      eurusd_low_price_array.push(eurusd_2year.low_price.to_f)
      eurusd_high_price_array.push(eurusd_2year.high_price.to_f)
      eurusd_close_price_array.push(eurusd_2year.close_price.to_f)
      eurusd_position_quantity_array.push(eurusd_2year.position_quantity.to_i)
      eurusd_trade_quantity_array.push(eurusd_2year.trade_quantity.to_i)
    end
    @eurusd_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロドル:FXチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories:eurusd_trade_date_array, tickInterval: 60)
      f.yAxis [
        {:title => {:text => 'EUR/USD'}, :min => 1.0, :max => 1.4, tickInterval: 0.05 , format: '{value} ＄'},
      ]
#      f.series(:yAxis => 0, :type => 'line', name: 'Low Pirce'  , data: eurusd_low_price_array  , pointFormat: 'Low Price:   <b>{point.y:.3f} ＄</b>')
#      f.series(:yAxis => 0, :type => 'line', name: 'High Pirce' , data: eurusd_high_price_array , pointFormat: 'High Price:  <b>{point.y:.3f} ＄</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'Close Pirce', data: eurusd_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} ＄</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(25 day)'  , data: eurusd_avg_rate_25d_avg  , pointFormat: '移動平均線(25 day):   <b>{point.y:.3f} ＄</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(75 day)'  , data: eurusd_avg_rate_75d_avg  , pointFormat: '移動平均線(75 day):   <b>{point.y:.3f} ＄</b>')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(100 day)'  , data: eurusd_avg_rate_100d_avg  , pointFormat: '移動平均線(100 day):   <b>{point.y:.3f} ＄</b>')
    end
    @eurusd_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロドル:FXポシションチャート')
      f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
      f.xAxis(categories: eurusd_trade_date_array, tickInterval: 60)
      f.yAxis [
       {:title => {:text => 'EUR/USD 建玉量'}, labels: {tickInterval: 5000, format: '{value} 枚'}},
       {:title => {:text => 'EUR/USD 取引量'}, labels: {tickInterval: 1000, format: '{value} 枚'}, opposite: true}, 
      ]
      f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: eurusd_position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
      f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: eurusd_trade_quantity_array, pointFormat: '取引数量: <b>{point.y} 枚</b>')
    end
      
    str = ''
    # 'date,open,high,low,close,\n'
    # 行末に\nがあるとちゃんと表示されない。
    @usdjpy_2year.each_with_index do |usdjpy_2year, i|
      str = str + '\n' if i > 0
      str = str + usdjpy_2year.date + ','
      str = str + usdjpy_2year.open_price.to_s + ','
      str = str + usdjpy_2year.high_price.to_s + ','
      str = str + usdjpy_2year.low_price.to_s + ','
      str = str + usdjpy_2year.close_price.to_s
    end
    @fx_rate_ohlc = str
  end  
end
