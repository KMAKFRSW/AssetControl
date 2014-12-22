class AddSecurityNameToMarketData < ActiveRecord::Migration
  def change
    add_column :market_data, :security_name, :string
  end
end
