#encoding: utf-8

class FxPerformanceController < ApplicationController
  def index
    ########################################################
    # get daily rate for USD/JPY, EUR/JPY, EUR/USD        # 
    ########################################################
    @usdjpy_term_risk, @eurjpy_term_risk, @eurusd_term_risk = FxPerformance.get_term_risk()
    
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

    @usdjpy_term_risk.each do |usdjpy_term_risk|
      wk_date = usdjpy_term_risk.date
      usdjpy_date_usdjpy.push(usdjpy_term_risk.date)
      while usdjpy_term_risk.date == wk_date do
        case usdjpy_term_risk.item
        when item_risk_1m then
          usdjpy_term_risk_usdjpy_1m.push(usdjpy_term_risk.data.to_f)
        when item_risk_3m then
          usdjpy_term_risk_usdjpy_3m.push(usdjpy_term_risk.data.to_f)
        when item_risk_6m then
          usdjpy_term_risk_usdjpy_16m.push(usdjpy_term_risk.data.to_f)
        when item_risk_12m then
          usdjpy_term_risk_usdjpy_12m.push(usdjpy_term_risk.data.to_f)
        end
        wk_date = usdjpy_term_risk.date
      end
    end
    
    @usdjpy_term_risk_graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: 'ドル円：HVチャート')
      f.plotOptions(line: {marker: {radius: 0}})
      f.xAxis(categories: usdjpy_date_usdjpy, tickInterval: 0.5)
      f.yAxis(:title => {:text => 'USD/JPY HV'}, :min => 0, :max => 3, tickInterval: 5 )
      f.series(:type => 'line', name: 'HV(1 month)'   , data: usdjpy_term_risk_usdjpy_1m  , pointFormat: 'HV(1 month): <b>{point.y:.3f}</b>')
    end
  end
end
