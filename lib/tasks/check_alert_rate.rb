#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/market_data_price"
require "#{Rails.root}/app/models/market_data"
require "#{Rails.root}/app/models/alerts"
require "#{Rails.root}/app/models/alert_mail"
require "#{Rails.root}/app/models/user"
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
  
  def self.check_technical_indicator( asset_class, region_code)
    
    # get target currencies
    array_universe, data_date = Universe.get_universe(asset_class, region_code)
       
    # compare current rate by user's alert settings
    array_universe.each do |universe|
      CheckAlert.compare_technical_with_rate(universe)
    end
    
    # send email
    alert_mails = AlertMail.find_by_sql(["select * from alert_mails where status = ? ",'0'])
    alert_mails.each do |alert_mail|
      AlertMailer.send_alert_email(alert_mail).deliver
    end      
  end
  
end
