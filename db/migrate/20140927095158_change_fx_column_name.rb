class ChangeFxColumnName < ActiveRecord::Migration
  rename_column :fx, :trade_type, :trade_type
end
