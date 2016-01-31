class CreateAlertMails < ActiveRecord::Migration
  def change
    create_table :alert_mails do |t|
      t.integer :user_id
      t.string :subject
      t.string :to
      t.string :from
      t.text :body

      t.timestamps
    end
  end
end
