class ChangeFxName < ActiveRecord::Migration
 rename_table :fx, :fx_trade
end
