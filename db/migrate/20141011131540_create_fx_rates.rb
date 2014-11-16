class CreateFxRates < ActiveRecord::Migration
  def change
    create_table :fx_rates do |t|
      t.string :data_kbn
      t.string :trade_date
      t.string :product_code1
      t.string :product_code2
      t.string :product_name
      t.string :prev_price
      t.string :open_price
      t.string :open_price_time
      t.string :high_price
      t.string :high_price_time
      t.string :low_price
      t.string :low_price_time
      t.string :close_price
      t.string :close_price_time
      t.string :today_price
      t.string :prev_changes
      t.string :swap
      t.string :trade_quantity
      t.string :position_quantity

      t.timestamps
    end
  end
end
