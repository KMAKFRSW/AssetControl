class CreateFxes < ActiveRecord::Migration
  def change
    create_table :fx do |t|
      t.string :order_no
      t.string :trade_date
      t.string :position_no
      t.string :currency
      t.string :trada_type
      t.string :quantity
      t.decimal :price
      t.decimal :commission
      t.decimal :sw_gain
      t.decimal :realized_gain
      t.decimal :sum_gain

      t.timestamps
    end
  end
end
