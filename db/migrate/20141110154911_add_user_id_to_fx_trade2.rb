class AddUserIdToFxTrade2 < ActiveRecord::Migration
  def change
    change_column :fx_trade, :user_id, :integer
  end
end
