class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id
      t.string :code
      t.string :alertvalue
      t.text :memo
      t.string :checkrule
      t.string :status

      t.timestamps
    end
  end
end
