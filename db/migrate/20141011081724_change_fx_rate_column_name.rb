class ChangeFxRateColumnName < ActiveRecord::Migration
  rename_column :fx_rates, :changes, :prev_changes
end
