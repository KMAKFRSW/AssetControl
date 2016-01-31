class AddBodyToAlertMailer < ActiveRecord::Migration
  def change
    add_column :alert_mails, :body1, :text
    add_column :alert_mails, :body2, :text
    add_column :alert_mails, :status, :string
  end
end
