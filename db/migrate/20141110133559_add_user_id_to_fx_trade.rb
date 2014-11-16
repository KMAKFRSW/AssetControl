class AddUserIdToFxTrade < ActiveRecord::Migration
  def change
    add_column :fx_trade, :user_id, :string
  end
end
