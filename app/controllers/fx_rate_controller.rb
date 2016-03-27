#encoding: utf-8

class FxRateController < ApplicationController
  def index
    ########################################################
    # get recent rates of each currencies                  #
    ########################################################
    @latest_rate = FxRate.get_latest_rate()
    @usdjpy_rate_graph, @usdjpy_position_graph = make_rate_and_position_graph('USD/JPY', 'ドル円', '円')
    @eurjpy_rate_graph, @eurjpy_position_graph = make_rate_and_position_graph('EUR/JPY', 'ユーロ円', '円')
    @eurusd_rate_graph, @eurusd_position_graph = make_rate_and_position_graph('EUR/USD', 'ユーロドル', 'ドル')
    @audjpy_rate_graph, @audjpy_position_graph = make_rate_and_position_graph('AUD/JPY', '豪ドル円', '円')
    @audusd_rate_graph, @audusd_position_graph = make_rate_and_position_graph('AUD/USD', '豪ドルドル', 'ドル')
    @gbpjpy_rate_graph, @gbpjpy_position_graph = make_rate_and_position_graph('GBP/JPY', 'ポンド円', '円')
    @gbpusd_rate_graph, @gbpusd_position_graph = make_rate_and_position_graph('GBP/USD', 'ポンドドル', 'ドル')
    @nzdjpy_rate_graph, @gbpjpy_position_graph = make_rate_and_position_graph('NZD/JPY', 'ニュージーランド円', '円')
    @cadjpy_rate_graph, @gbpjpy_position_graph = make_rate_and_position_graph('CAD/JPY', 'カナダドル円', '円')
    
  end
  
  def make_rate_and_position_graph(cur_code, cur_name, unit)
    
    # define each item codes
    item_rate_5d_avg      = Settings[:item_fx][:rate_5d_avg]
    item_rate_25d_avg     = Settings[:item_fx][:rate_25d_avg]
    item_rate_75d_avg     = Settings[:item_fx][:rate_75d_avg]
    item_rate_100d_avg    = Settings[:item_fx][:rate_100d_avg]
    item_rate_200d_avg    = Settings[:item_fx][:rate_200d_avg]

    # make array including the values to show chart of USD/JPY
    trade_date_array        = Array.new
    close_price_array       = Array.new
    position_quantity_array = Array.new
    trade_quantity_array    = Array.new
    avg_rate_5d_avg      = Array.new
    avg_rate_25d_avg     = Array.new
    avg_rate_75d_avg     = Array.new
    avg_rate_100d_avg    = Array.new
    avg_rate_200d_avg    = Array.new
    avg_rate_array       = Array.new
    
    @rate_1year = FxRate.get_daily_rate(cur_code)
    @avg_rate_for_some_term = FxPerformance.get_avg_daily_rate(cur_code)

    @avg_rate_for_some_term.each do |avg_rate|
      # judging from item, store data to each array
      case avg_rate.item
      when item_rate_5d_avg then
        avg_rate_5d_avg.push(avg_rate.data.to_f)
      when item_rate_25d_avg then
        avg_rate_25d_avg.push(avg_rate.data.to_f)
      when item_rate_75d_avg then
        avg_rate_75d_avg.push(avg_rate.data.to_f)
      when item_rate_100d_avg then
        avg_rate_100d_avg.push(avg_rate.data.to_f)
      when item_rate_200d_avg then
        avg_rate_200d_avg.push(avg_rate.data.to_f)
      end
    end

    @rate_1year.each do |rate_1year|
      trade_date_array.push(rate_1year.date)
      close_price_array.push(rate_1year.close_price.to_f)
      position_quantity_array.push(rate_1year.position_quantity.to_i)
      trade_quantity_array.push(rate_1year.trade_quantity.to_i)
    end
    
    if cur_code[4..6] == 'JPY'
      max = close_price_array.max.round(0)
      min = close_price_array.min.round(0)
      interval = (max-min)/10
    else
      max = close_price_array.max.round(2)
      min = close_price_array.min.round(2)
      interval = (max-min)/10
    end
    
    rate_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: cur_name+':FXチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: trade_date_array, tickInterval: 60)
      f.yAxis [
        {:title => {:text => cur_code}, :min => min, :max => max, tickInterval: interval, format: '{value} '+ unit},
      ]
      f.series(:yAxis => 0, :type => 'line', name: 'Close Pirce', data: close_price_array, pointFormat: 'Close Price')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(25 day)'  , data: avg_rate_25d_avg  , pointFormat: '移動平均線(25 day):')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(75 day)'  , data: avg_rate_75d_avg  , pointFormat: '移動平均線(75 day):')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(100 day)'  , data: avg_rate_100d_avg  , pointFormat: '移動平均線(100 day):')
      f.series(:yAxis => 0, :type => 'line', name: '移動平均線(200 day)'  , data: avg_rate_200d_avg  , pointFormat: '移動平均線(200 day):')
    end

    position_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: cur_name+':FXポシションチャート')
      f.plotOptions(line: {marker: {radius: 0}}, area: {marker: {radius: 0}})
      f.xAxis(categories: trade_date_array, tickInterval: 60) 
      f.yAxis [
       {:title => {:text => cur_code+' 建玉量'}, labels: {tickInterval: 100000, format: '{value} 枚'}},
       {:title => {:text => cur_code+' 取引量'}, labels: {tickInterval: 10000 , format: '{value} 枚'} , opposite: true}
      ]
      f.series(:yAxis => 0, :type => 'area', name: '建玉数量', data: position_quantity_array, pointFormat: '建玉数量: <b>{point.y} 枚</b>')
      f.series(:yAxis => 1, :type => 'line', name: '取引数量', data: trade_quantity_array   , pointFormat: '取引数量: <b>{point.y} 枚</b>')
    end
    
    return rate_graph, position_graph
    
  end
  
end
