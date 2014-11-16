#encoding: utf-8

class FxtradeController < ApplicationController
before_filter :authenticate_user!

  def index
    # 現在のユーザIDを取得
    user_id = current_user.id

    @fx_avg = Fxtrade.avg(user_id)
    @fx_best10 = Fxtrade.best10(user_id)
    @fx_worst10 = Fxtrade.worst10(user_id)
    @fx_last_30_day = Fxtrade.last_30_day(user_id)
    @fx_last_5_week = Fxtrade.last_5_week(user_id)
    #月次損利益チャート用配列作成
    @fx_monthly_interest = Fxtrade.monthly_interest(user_id)
      i = 0
      monthly_interest_array = Array.new
      monthly_interest_month_array = Array.new
      @fx_monthly_interest.each do |interest|
        monthly_interest_month_array.push(interest.month)
        monthly_interest_array.push(interest.sum_gain)
        i = i + 1
      end
      @fx_monthly_interest_graph = LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: 'FX:月次損益チャート')
        f.chart(:type => 'column')
        f.plotOptions(line: {marker: {radius: 0}})
        f.xAxis(categories: monthly_interest_month_array, tickInterval: 1)
        f.yAxis(:min => -400000, :max => 400000, tickInterval: 100000, :title => {:text => 'Monthly Interest'}, labels: {format: '{value} 円'})
        f.series(name: 'Monthly Interest', data: monthly_interest_array, pointFormat: 'Low Price: <b>{point.y} 円</b>')
      end
  end

  def upload_fx_csv
    # 現在のユーザIDを取得
    user_id = current_user.id

    if params[:upfile].blank?
      flash[:alert] = 'アップロードされたファイルはありません。' 
      redirect_to( {:action => 'upload_csv'}, {notice => 'アップロードに成功しました。'})
    else
      Fxtrade.load_csv(params[:upfile], user_id)
      flash[:notice] = 'アップロードに成功しました。' 
      redirect_to( {:action => 'upload_csv'}, {notice => 'アップロードに成功しました。'})
    end
  end

  def daily_detail
    # 現在のユーザIDを取得
    user_id = current_user.id
    @fx_daily_detail = Fxtrade.daily_detail(params[:trade_date], user_id)
  end
end
