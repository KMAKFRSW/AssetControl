#encoding: utf-8
require 'date'
require "#{Rails.root}/app/models/alert_mail"

class AlertMailer < ActionMailer::Base
  default from: "mailfromassetcontrol@gmail.com"
  
  def send_alert_email(alert_mail)
    @body = alert_mail.body
    @body1 = alert_mail.body1
    mail(
    to: alert_mail.to, 
    subject: alert_mail.subject
    ) do |format|
      format.html
    end
    
    @AlertMail = AlertMail.find_by_id(alert_mail[:id])
    @AlertMail.attributes = {
        :status => '1'
    }
    @AlertMail.save!    
  end
  
end
