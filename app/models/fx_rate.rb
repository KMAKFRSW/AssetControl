#encoding: utf-8

class FxRate < ActiveRecord::Base
  attr_accessible :close_price, :close_price_time, :data_kbn, :high_price, :high_price_time, :low_price, :low_price_time, :open_price, :open_price_time, :position_quantity, :prev_changes, :prev_price, :product_code1, :product_code2, :product_name, :swap, :today_price, :trade_date, :trade_quantity

  self.table_name = 'fx_rates'
  self.primary_keys = :trade_date, :product_code2
  
  REAL_ATTRIBUTE_NAMES = {
    :trade_date => 'データ基準日', 
    :product_code2 => '通貨', 
    :open_price => '始値', 
    :high_price => '高値', 
    :low_price => '安値', 
    :close_price => '終値', 
    :prev_changes => '前日比', 
    :swap => 'Swap', 
    :trade_quantity => '取引数量',
    :position_quantity => '建玉数量'
  }
  
  def self.real_attribute_name(key)
    REAL_ATTRIBUTE_NAMES[key.to_sym]
  end

  def self.get_latest_rate
     find_by_sql(["select date_format(max.date,'%Y/%m/%d') as recent_date, product_code2, open_price, high_price, low_price, close_price, prev_changes, swap, trade_quantity, position_quantity from fx_rates, ( select distinct MAX(trade_date) as date from fx_rates ) max
      where trade_date = max.date
      and product_code2 IN ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,? )
      order by cast(trade_quantity as unsigned) desc
       ", 'USD/JPY', 'EUR/JPY','GBP/JPY', 'AUD/JPY','CHF/JPY', 'CAD/JPY', 'NZD/JPY', 'ZAR/JPY', 'EUR/USD', 'GBP/USD', 'AUD/USD', 'NZD/USD', 'TRY/JPY'])
  end

  def self.get_update_date
     find_by_sql(["select date_format(latest_date.date,?) as date from 
       (select max(updated_at) as date from fx_rates) as latest_date", '%Y/%m/%d %H:%i %s秒'])
  end

  def self.get_daily_rate(cur_code)
     rate_1year = find_by_sql(["select date_format(trade_date, '%Y/%m/%d') as date, open_price, high_price, low_price, close_price, trade_quantity, position_quantity from fx_rates
       where trade_date > date_format(now() - INTERVAL 2 YEAR,'%Y%m%d')
       and product_code2 = ?
       order by trade_date asc
       ", cur_code])
       
       return rate_1year
       
  end
end
