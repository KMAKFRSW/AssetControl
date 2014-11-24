#encoding: utf-8

class FxPerformanceController < ApplicationController
  def index
    ########################################################
    # get daily rate for USD/JPY, EUR/JPY, EUR/USD        # 
    ########################################################
    @usdjpy_term_risk, @eurjpy_term_risk, @usdeur_term_risk = FxPerformance.get_term_risk()
    
    ########################################################
    # variable for chart of USD/JPY                        #
    ########################################################
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

    # make array including the values to show chart of USD/JPY
    usdjpy_date_usdjpy          = Array.new
    usdjpy_term_risk_usdjpy_1m  = Array.new
    usdjpy_term_risk_usdjpy_3m  = Array.new
    usdjpy_term_risk_usdjpy_6m  = Array.new
    usdjpy_term_risk_usdjpy_12m = Array.new

    wk_date = nil
    
    @usdjpy_term_risk.each do |usdjpy_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != usdjpy_term_risk.date then
        usdjpy_date_usdjpy.push(usdjpy_term_risk.date)
      end
      # restore wk_date
      wk_date = usdjpy_term_risk.date        
      # judging from item, store data to each array
      case usdjpy_term_risk.item
      when item_risk_1m then
        usdjpy_term_risk_usdjpy_1m.push(usdjpy_term_risk.data.to_f)
      when item_risk_3m then
        usdjpy_term_risk_usdjpy_3m.push(usdjpy_term_risk.data.to_f)
      when item_risk_6m then
        usdjpy_term_risk_usdjpy_6m.push(usdjpy_term_risk.data.to_f)
      end
    end
    
    @usdjpy_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_date_usdjpy, tickInterval: 20)
      f.yAxis(:title => {:text => 'USD/JPY Historical Volatility'}, :min => 0, :max => 5, tickInterval: 0.5 )
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: usdjpy_term_risk_usdjpy_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f}</b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: usdjpy_term_risk_usdjpy_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f}</b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: usdjpy_term_risk_usdjpy_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f}</b>')
    end

    # make array including the values to show chart of EUR/JPY
    eurjpy_date_eurjpy          = Array.new
    eurjpy_term_risk_eurjpy_1m  = Array.new
    eurjpy_term_risk_eurjpy_3m  = Array.new
    eurjpy_term_risk_eurjpy_6m  = Array.new
    eurjpy_term_risk_eurjpy_12m = Array.new

    wk_date = nil
    
    @eurjpy_term_risk.each do |eurjpy_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != eurjpy_term_risk.date then
        eurjpy_date_eurjpy.push(eurjpy_term_risk.date)
      end
      # restore wk_date
      wk_date = eurjpy_term_risk.date        
      # judging from item, store data to each array
      case eurjpy_term_risk.item
      when item_risk_1m then
        eurjpy_term_risk_eurjpy_1m.push(eurjpy_term_risk.data.to_f)
      when item_risk_3m then
        eurjpy_term_risk_eurjpy_3m.push(eurjpy_term_risk.data.to_f)
      when item_risk_6m then
        eurjpy_term_risk_eurjpy_6m.push(eurjpy_term_risk.data.to_f)
      end
    end
    
    @eurjpy_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロ円：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: eurjpy_date_eurjpy, tickInterval: 20)
      f.yAxis(:title => {:text => 'EUR/JPY Historical Volatility'}, :min => 0, :max => 5, tickInterval: 0.5 )
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: eurjpy_term_risk_eurjpy_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f}</b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: eurjpy_term_risk_eurjpy_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f}</b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: eurjpy_term_risk_eurjpy_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f}</b>')
    end
    
    # make array including the values to show chart of USD/EUR
    usdeur_date_usdeur          = Array.new
    usdeur_term_risk_usdeur_1m  = Array.new
    usdeur_term_risk_usdeur_3m  = Array.new
    usdeur_term_risk_usdeur_6m  = Array.new
    usdeur_term_risk_usdeur_12m = Array.new

    wk_date = nil
    
    @usdeur_term_risk.each do |usdeur_term_risk|
      # if date is changed, store new date to array for date
      if wk_date != usdeur_term_risk.date then
        usdeur_date_usdeur.push(usdeur_term_risk.date)
      end
      # restore wk_date
      wk_date = usdeur_term_risk.date        
      # judging from item, store data to each array
      case usdeur_term_risk.item
      when item_risk_1m then
        usdeur_term_risk_usdeur_1m.push(usdeur_term_risk.data.to_f)
      when item_risk_3m then
        usdeur_term_risk_usdeur_3m.push(usdeur_term_risk.data.to_f)
      when item_risk_6m then
        usdeur_term_risk_usdeur_6m.push(usdeur_term_risk.data.to_f)
      end
    end
    
    @usdeur_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ユーロドル：Historical Volatility チャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdeur_date_usdeur, tickInterval: 20)
      f.yAxis(:title => {:text => 'USD/EUR Historical Volatility'}, :min => 0, :max => 0.06, tickInterval: 0.01 )
      f.series(:type => 'line', name: 'Historical Volatility(1 month)'   , data: usdeur_term_risk_usdeur_1m  , pointFormat: 'Historical Volatility(1 month): <b>{point.y:.3f}</b>')
      f.series(:type => 'line', name: 'Historical Volatility(3 month)'   , data: usdeur_term_risk_usdeur_3m  , pointFormat: 'Historical Volatility(3 month): <b>{point.y:.3f}</b>')
      f.series(:type => 'line', name: 'Historical Volatility(6 month)'   , data: usdeur_term_risk_usdeur_6m  , pointFormat: 'Historical Volatility(6 month): <b>{point.y:.3f}</b>')
    end

  end
end
