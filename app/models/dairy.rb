#encoding: utf-8

class Dairy < ActiveRecord::Base
  attr_accessible :comment, :trade_date, :user_id
  
  self.table_name = 'dairies'
  
  belongs_to :user, dependent: :destroy

  # define the name of attributes
  REAL_ATTRIBUTE_NAMES = {
    :trade_date => '日付',
    :comment => 'コメント'
  }
  
  def self.show(trade_date, user_id)
     find_by_sql(["select date_format(cast(trade_date as date),'%Y/%m/%d') as Date, comment from dairies
      where date_format(trade_date,'%Y/%m/%d') = ?
      and user_id = ?
      order by trade_date asc", trade_date, user_id])
  end

  def self.update(comment ,trade_date, user_id)
    if Dairy.exists?({ :trade_date => trade_date, :user_id => user_id })
      @dairy = Dairy.find_by_user_id_and_trade_date(user_id, trade_date)
      @dairy.attributes = {
          :comment => comment
      }
      @dairy.save!
    else
      Dairy.create!(
          :user_id => user_id, 
          :trade_date => trade_date, 
          :comment => comment
      )
    end
  end
end
