#encoding: utf-8

class FxRateController < ApplicationController
  def index
    ###################################
    # 各国通貨直近レート取得
    ###################################
    @latest_rate = FxRate.get_latest_rate()
     
    ###################################
    # ドル円チャート表示用インスタンス変数
    ###################################
    @usdjpy_1year = FxRate.get_usdjpy_1year()    
      i = 0
      usdjpy_trade_date_array = Array.new
      usdjpy_low_price_array = Array.new
      usdjpy_high_price_array = Array.new
      usdjpy_close_price_array = Array.new
      usdjpy_position_quantity_array = Array.new
      usdjpy_trade_quantity_array = Array.new
  
      arr = Array.new(365){ Array.new(5) }
  
      @usdjpy_1year.each do |usdjpy_1year|
        usdjpy_trade_date_array.push(usdjpy_1year.date)
        usdjpy_low_price_array.push(usdjpy_1year.low_price.to_f)
        usdjpy_high_price_array.push(usdjpy_1year.high_price.to_f)
        usdjpy_close_price_array.push(usdjpy_1year.close_price.to_f)
        usdjpy_position_quantity_array.push(usdjpy_1year.position_quantity.to_i)
        usdjpy_trade_quantity_array.push(usdjpy_1year.trade_quantity.to_i)
        
        # wrk
#        arr[i][0] = usdjpy_1year.date.to_date 
#        arr[i][1] = usdjpy_1year.open_price.to_f
#        arr[i][2] =  usdjpy_1year.low_price.to_f
#        arr[i][3] =  usdjpy_1year.high_price.to_f
#        arr[i][4] =  usdjpy_1year.close_price.to_f

        i = i + 1
      end
      @usdjpy_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: 'ドル円:FXチャート')
        f.chart(:type => 'line')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: usdjpy_trade_date_array, tickInterval: 10)
        f.yAxis(:min => 100, :max => 116, tickInterval: 5, :title => {:text => 'USD/JPY'}, labels: {format: '{value} 円'})
        f.series(name: 'Low Pirce', data: usdjpy_low_price_array, pointFormat: 'Low Price: <b>{point.y:.3f} 円</b>')
        f.series(name: 'High Pirce', data: usdjpy_high_price_array, pointFormat: 'High Price: <b>{point.y:.3f} 円</b>')
        f.series(name: 'Close Pirce', data: usdjpy_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} 円</b>')
      end
      @usdjpy_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: 'ドル円:FXポシションチャート')
        f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
        f.xAxis(categories: usdjpy_trade_date_array, tickInterval: 10) 
        f.yAxis [
         {:title => {:text => 'USD/JPY 建玉量'}, labels: {:min => 150000, :max => 1500000, tickInterval: 100000, format: '{value} 枚'}},
         {:title => {:text => 'USD/JPY 取引量'}, labels: {:min => 0, :max => 100000, tickInterval: 10000, format: '{value} 枚'}, opposite: true}, 
        ]
        f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: usdjpy_position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
        f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: usdjpy_trade_quantity_array, pointFormat: '取引数量: <b>{point.y} 枚</b>')
      end
      
      #wrk
      @usdjpy_ohlc_graph = LazyHighCharts::HighChart.new('StockChart') do |f|
        f.title(text: 'ドル円:FXohlcチャート')
        f.rangeSelector(selected: 1)
        f.yAxis(:min => 100, :max => 115, tickInterval: 5, :title => {:text => 'USD/JPY'}, labels: {format: '{value} 円'})
        f.xAxis(categories: usdjpy_trade_date_array, tickInterval: 10) 
        f.series(name: 'USD/JPY', :type => 'candlestick', data: arr, dataGrouping: {units: ['month', [1, 2, 3, 4, 6]]})
      end

    ###################################
    # ユーロ円チャート表示用インスタンス変数
    ###################################
    @eurjpy_1year = FxRate.get_eurjpy_1year()    
      i = 0
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
        i = i + 1
      end
      @eurjpy_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: 'ユーロ円:FXチャート')
        f.chart(:type => 'line')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: eurjpy_trade_date_array, tickInterval: 10)
        f.yAxis(:min => 125, :max => 150, tickInterval: 5, :title => {:text => 'EUR/JPY'}, labels: {format: '{value} 円'}, minRange: '5')
        f.series(name: 'Low Pirce', data: eurjpy_low_price_array, pointFormat: 'Low Price: <b>{point.y:.3f} 円</b>')
        f.series(name: 'High Pirce', data: eurjpy_high_price_array, pointFormat: 'High Price: <b>{point.y:.3f} 円</b>')
        f.series(name: 'Close Pirce', data: eurjpy_close_price_array, pointFormat: 'Close Price: <b>{point.y:.3f} 円</b>')
      end
      @eurjpy_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: 'ユーロ円:FXポシションチャート')
        f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
        f.xAxis(categories: eurjpy_trade_date_array, tickInterval: 10) 
        f.yAxis [
         {:title => {:text => 'EUR/JPY 建玉量'}, labels: {:min => 10000, :max => 100000, tickInterval: 1000, format: '{value} 枚'}},
         {:title => {:text => 'EUR/JPY 取引量'}, labels: {:min => 0, :max => 50000, tickInterval: 1000, format: '{value} 枚'}, opposite: true}, 
        ]
        f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: eurjpy_position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
        f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: eurjpy_trade_quantity_array, pointFormat: '取引数量: <b>{point.y} 枚</b>')
      end

    ###################################
    # ユーロドルチャート表示用インスタンス変数
    ###################################
    @eurusd_1year = FxRate.get_eurusd_1year()    
      i = 0
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
        i = i + 1
      end
      @eurusd_price_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: 'ユーロドル:FXチャート')
        f.chart(:type => 'line')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: eurusd_trade_date_array, tickInterval: 10)
        f.yAxis(:min => 1.2, :max => 1.45, tickInterval: 0.05, :title => {:text => 'EUR/USD'}, labels: {format: '{value} $'})
        f.series(name: 'Low Pirce', data: eurusd_low_price_array, pointFormat: 'Low Price: <b>{point.y:.4f} $</b>')
        f.series(name: 'High Pirce', data: eurusd_high_price_array, pointFormat: 'High Price: <b>{point.y:.4f} $</b>')
        f.series(name: 'Close Pirce', data: eurusd_close_price_array, pointFormat: 'Close Price: <b>{point.y:.4f} $</b>')
      end
      @eurusd_position_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: 'ユーロドル:FXポシションチャート')
        f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
        f.xAxis(categories: eurusd_trade_date_array, tickInterval: 10)
        f.yAxis [
         {:title => {:text => 'EUR/USD 建玉量'}, labels: {:min => 5000, :max => 30000, tickInterval: 5000, format: '{value} 枚'}},
         {:title => {:text => 'EUR/USD 取引量'}, labels: {:min => 0, :max => 10000, tickInterval: 1000, format: '{value} 枚'}, opposite: true}, 
        ]
        f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: eurusd_position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
        f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: eurusd_trade_quantity_array, pointFormat: '取引数量: <b>{point.y} 枚</b>')
      end

   end
end
