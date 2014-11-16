class ChangeFxPrice < ActiveRecord::Migration
  change_column :fx, :price, :decimal, :precision => 10, :scale => 3
end
