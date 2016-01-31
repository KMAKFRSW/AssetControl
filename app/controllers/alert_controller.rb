#encoding: utf-8

class AlertController < ApplicationController
  def index
    # get current logined user id
    user_id = current_user.id
    
    # get the data of trade peforemance summary for chart
    @alerts = Alerts.get_alerts(user_id)
    
  end
  
  def edit_all
    # get current logined user id
    user_id = current_user.id
    
    # get the data of trade peforemance summary for chart
    @alerts = Alerts.get_alerts(user_id)
    session[:alerts] = @alerts
  end

  def update_all
    # 20160130 underconstruction
  end

  def new
    # get current logined user id
    user_id = current_user.id
    @alert = Alerts.new
  end

  def create
    # get current logined user id
    user_id = current_user.id
    @alert = Alerts.new
    @alert.user_id = user_id
    @alert.code = params[:alerts]["code"]
    @alert.alertvalue = params[:alerts]["alertvalue"]
    @alert.checkrule =  params[:alert]["checkrule"]
    @alert.memo = params[:alerts]["memo"]
    @alert.status = 0
    
    if @alert.save
      # @userはuser_path(@user) に自動変換される
      flash[:notice]= "登録に成功しました。"
      redirect_to( {:action => 'index'})
    else
      # ValidationエラーなどでDBに保存できない場合 new.html.erb を再表示
      flash[:notice]= "登録に失敗しました。"
      render 'new'
    end
    
  end

  def destroy
    @alert = Alerts.find(params[:id])

    if @alert.destroy
      # @userはuser_path(@user) に自動変換される
      flash[:notice]= "削除しました。"
      redirect_to( {:action => 'index'})
    else
      # ValidationエラーなどでDBに保存できない場合 new.html.erb を再表示
      flash[:notice]= "削除に失敗しました。"
      redirect_to( {:action => 'index'})
    end

  end

  def edit
    @alert = Alerts.find(params[:id])
  end
  
  def update
    # get current logined user id
    @alert = Alerts.find(params[:id])
    @alert.code = params[:alerts]["code"]
    @alert.alertvalue = params[:alerts]["alertvalue"]
    @alert.checkrule =  params[:alert]["checkrule"]
    @alert.memo = params[:alerts]["memo"]
    @alert.status = 0
    
    if @alert.save
      # @userはuser_path(@user) に自動変換される
      flash[:notice]= "更新に成功しました。"
      redirect_to( {:action => 'index'})
    else
      # ValidationエラーなどでDBに保存できない場合 new.html.erb を再表示
      flash[:notice]= "更新に失敗しました。"
      redirect_to( {:action => 'index'})
    end
  end
  
end
