#encoding: utf-8

class FxtradeController < ApplicationController
before_filter :authenticate_user!

  def index
    # get current logined user id
    user_id = current_user.id
    
    # get the data of trade peforemance summary for chart
    @fx_avg = Fxtrade.avg(user_id)
    @fx_best10 = Fxtrade.best10(user_id)
    @fx_worst10 = Fxtrade.worst10(user_id)
    @fx_last_30_day = Fxtrade.last_30_day(user_id)
    @fx_last_5_week = Fxtrade.last_5_week(user_id)

    # make the array for monthly bar graph
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
        f.yAxis(:min => -1000000, :max => 1000000, tickInterval: 200000, :title => {:text => 'Monthly Interest'}, labels: {format: '{value} 円'})
        f.series(name: 'Monthly Interest', data: monthly_interest_array, pointFormat: 'Low Price: <b>{point.y} 円</b>')
      end
  end

  def upload_fx_csv
    # get the logined user id
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
    # get the logined user id
    user_id = current_user.id
    # show information of dairy trade detail
    @fx_daily_detail = Fxtrade.daily_detail(params[:trade_date], user_id)
    # show information of comment
    @dairy = Dairy.show(params[:trade_date], user_id)
  end
  
  def edit_comment
    # get the logined user id
    user_id = current_user.id
    # make the instancce for editting comment
    @dairy = Dairy.new
    # show information of dairy trade detail
    @fx_daily_detail = Fxtrade.daily_detail(params[:trade_date], user_id)
  end

  def update_comment
    # get the logined user id
    user_id = current_user.id
    comment = params[:dairy][:comment]
    trade_date = params[:trade_date]
    # update diry model
    Dairy.update(comment, trade_date, user_id)
    redirect_to(daily_detail_user_fxtrade_index_path(:trade_date => trade_date), {notice => '編集に成功しました。'})
  end
  
end
