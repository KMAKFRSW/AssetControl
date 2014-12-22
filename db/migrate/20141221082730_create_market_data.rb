#encoding: utf-8

class CreateMarketData < ActiveRecord::Migration
  def change
    create_table :market_data do |t|
      t.string :security_code
      t.string :vendor_code
      t.string :market_code
      t.date :from_date
      t.date :to_date
      t.string :asset_class
      t.string :region_code

      t.timestamps
    end
  end
end
