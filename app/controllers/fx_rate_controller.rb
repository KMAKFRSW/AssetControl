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
    @usdjpy_1year, @eurjpy_1year, @eurusd_1year = FxRate.get_daily_rate()
     
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

    @usdjpy_1year.each do |usdjpy_1year|
      usdjpy_trade_date_array.push(usdjpy_1year.date)
      usdjpy_low_price_array.push(usdjpy_1year.low_price.to_f)
      usdjpy_high_price_array.push(usdjpy_1year.high_price.to_f)
      usdjpy_close_price_array.push(usdjpy_1year.close_price.to_f)
      usdjpy_position_quantity_array.push(usdjpy_1year.position_quantity.to_i)
      usdjpy_trade_quantity_array.push(usdjpy_1year.trade_quantity.to_i)
    end
    
    @usdjpy_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円:FXチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_trade_date_array, tickInterval: 20)
      f.yAxis [
        {:title => {:text => 'USD/JPY'}, :min => 100, :max => 120, tickInterval: 5 , format: '{value} 円'},
      ]
      f.series(:yAxis => 0, :type => 'line', name: 'Low Pirce'  , data: usdjpy_low_price_array  , pointFormat: 'Low Price:   <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'High Pirce' , data: usdjpy_high_price_array , pointFormat: 'High Price:  <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'Close Pirce', data: usdjpy_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} 円</b>')
    end
    @usdjpy_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円:FXポシションチャート')
      f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_trade_date_array, tickInterval: 20) 
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
    
    @eurjpy_1year.each do |eurjpy_1year|
      eurjpy_trade_date_array.push(eurjpy_1year.date)
      eurjpy_low_price_array.push(eurjpy_1year.low_price.to_f)
      eurjpy_high_price_array.push(eurjpy_1year.high_price.to_f)
      eurjpy_close_price_array.push(eurjpy_1year.close_price.to_f)
      eurjpy_position_quantity_array.push(eurjpy_1year.position_quantity.to_i)
      eurjpy_trade_quantity_array.push(eurjpy_1year.trade_quantity.to_i)
    end

    @eurjpy_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロ円:FXチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories:eurjpy_trade_date_array, tickInterval: 20)
      f.yAxis [
        {:title => {:text => 'EUR/JPY'}, :min => 130, :max => 150, tickInterval: 5 , format: '{value} 円'},
      ]
      f.series(:yAxis => 0, :type => 'line', name: 'Low Pirce'  , data: eurjpy_low_price_array  , pointFormat: 'Low Price:   <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'High Pirce' , data: eurjpy_high_price_array , pointFormat: 'High Price:  <b>{point.y:.3f} 円</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'Close Pirce', data: eurjpy_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} 円</b>')
    end
    @eurjpy_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロ円:FXポシションチャート')
      f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
      f.xAxis(categories: eurjpy_trade_date_array, tickInterval: 20) 
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
    
    @eurusd_1year.each do |eurusd_1year|
      eurusd_trade_date_array.push(eurusd_1year.date)
      eurusd_low_price_array.push(eurusd_1year.low_price.to_f)
      eurusd_high_price_array.push(eurusd_1year.high_price.to_f)
      eurusd_close_price_array.push(eurusd_1year.close_price.to_f)
      eurusd_position_quantity_array.push(eurusd_1year.position_quantity.to_i)
      eurusd_trade_quantity_array.push(eurusd_1year.trade_quantity.to_i)
    end
    @eurusd_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロドル:FXチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories:eurusd_trade_date_array, tickInterval: 20)
      f.yAxis [
        {:title => {:text => 'EUR/USD'}, :min => 1.2, :max => 1.5, tickInterval: 0.1 , format: '{value} ＄'},
      ]
      f.series(:yAxis => 0, :type => 'line', name: 'Low Pirce'  , data: eurusd_low_price_array  , pointFormat: 'Low Price:   <b>{point.y:.3f} ＄</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'High Pirce' , data: eurusd_high_price_array , pointFormat: 'High Price:  <b>{point.y:.3f} ＄</b>')
      f.series(:yAxis => 0, :type => 'line', name: 'Close Pirce', data: eurusd_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} ＄</b>')
    end
    @eurusd_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロドル:FXポシションチャート')
      f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
      f.xAxis(categories: eurusd_trade_date_array, tickInterval: 20)
      f.yAxis [
       {:title => {:text => 'EUR/USD 建玉量'}, labels: {tickInterval: 5000, format: '{value} 枚'}},
       {:title => {:text => 'EUR/USD 取引量'}, labels: {tickInterval: 1000, format: '{value} 枚'}, opposite: true}, 
      ]
      f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: eurusd_position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
      f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: eurusd_trade_quantity_array, pointFormat: '取引数量: <b>{point.y} 枚</b>')
    end
  end
end
