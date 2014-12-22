class CreateMarketDataPrices < ActiveRecord::Migration
  def change
    create_table :market_data_prices do |t|
      t.string :security_code
      t.string :vendor_code
      t.string :market_code
      t.date :trade_date
      t.string :item
      t.string :data

      t.timestamps
    end
  end
end
