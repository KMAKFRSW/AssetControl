#encoding: utf-8

class Alerts < ActiveRecord::Base
  attr_accessible :alertvalue, :checkrule, :code, :memo, :user_id, :status, :id
  
  self.table_name = 'alerts'
  
  belongs_to :user

  validates_presence_of :alertvalue, :checkrule, :code, :user_id, :status

  # define the name of attributes
  REAL_ATTRIBUTE_NAMES = {
    :alertvalue => 'レート', 
    :checkrule => 'ルール',
    :code => 'コード', 
    :memo => '備考', 
    :status => '状態', 
    :user_id=> 'ユーザID',
    :updated_at=> '更新日時'
  }
  
  def self.real_attribute_name(key)
    REAL_ATTRIBUTE_NAMES[key.to_sym]
  end

  def self.get_alerts(user_id)
     find_by_sql(["select id, code, checkrule, alertvalue, memo, status, DATE_FORMAT(updated_at,'%Y/%m/%d/ %k:%i') as UpdateDate from alerts
      where user_id = ?
      order by code,alertvalue desc", user_id])
  end

  def self.get_all_unchecked_alerts(universe)
    # status 0の設定を抽出する
     find_by_sql(["select id, user_id, code, checkrule, alertvalue, memo, status from alerts
      where status = ?
      and code = ?
      order by code", '0', universe.security_code])
  end
  
end
