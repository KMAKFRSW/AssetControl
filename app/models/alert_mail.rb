class AlertMail < ActiveRecord::Base
  attr_accessible :body, :from, :subject, :to, :user_id, :body1, :body2, :status, :id
  self.table_name = 'alert_mails'
  belongs_to :user

end
