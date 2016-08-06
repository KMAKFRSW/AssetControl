#encoding: utf-8

require 'date'
require "#{Rails.root}/lib/tasks/tool/http_client"
require "#{Rails.root}/lib/tasks/tool/acquirer"
require "#{Rails.root}/lib/tasks/tool/universe"
include CheckAlert

class Tasks::Check_Alert_Rate
  def self.check_alert_setting( asset_class, region_code)
    # get target currencies
    array_universe, data_date = Universe.get_universe(asset_class, region_code)
    # compare current rate by user's alert settings
    array_universe.each do |universe|
      CheckAlert.check_alert_rate(universe)
    end
    # send email
    alert_mails = AlertMail.find_by_sql(["select * from alert_mails where status = ? ",'0'])
    alert_mails.each do |alert_mail|
      AlertMailer.send_alert_email(alert_mail).deliver
    end   
  end
  
  def self.reflect_alert_setting( asset_class, region_code, user_id)
    # delete previous setting
    Alerts.destroy_all("memo like '%自動設定%'")
    # get target currencies
    array_universe, data_date = Universe.get_universe(asset_class, region_code)
    # compare current rate by user's alert settings
    array_universe.each do |universe|
#      Technical_Indicator.reflect_pivot_to_alert(universe, user_id)
      Technical_Indicator.reflect_bb_to_alert(universe, user_id)
      Technical_Indicator.reflect_ma_to_alert(universe, user_id)
    end          
  end
    
end
