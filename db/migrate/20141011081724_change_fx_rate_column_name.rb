class ChangeFxRateColumnName < ActiveRecord::Migration
  rename_column :fx_rate, :changes, :prev_changes
end
