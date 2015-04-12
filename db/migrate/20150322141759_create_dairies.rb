class CreateDairies < ActiveRecord::Migration
  def change
    create_table :dairies do |t|
      t.integer :user_id
      t.string :trade_date
      t.text :comment

      t.timestamps
    end
  end
end
