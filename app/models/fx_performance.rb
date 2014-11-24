#encoding: utf-8

class FxPerformance < ActiveRecord::Base
  attr_accessible :calc_date, :cur_code, :data, :item

  self.table_name = 'fx_performances'

  def self.get_daily_range()
      
     usdjpy_range = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'USD/JPY', 'RNG01'])
       
     eurjpy_range = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'EUR/JPY', 'RNG01'])
       
     eurusd_range = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'EUR/USD', 'RNG01'])
       
       return usdjpy_range, eurjpy_range, eurusd_range 
     
  end
  
  def self.get_term_risk()
     usdjpy_term_risk = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 5 MONTH,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'USD/JPY', 'RSK%'])

     eurjpy_term_risk = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 5 MONTH,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/JPY', 'RSK%'])

     usdeur_term_risk = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 5 MONTH,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/USD', 'RSK%'])

       return usdjpy_term_risk, eurjpy_term_risk, usdeur_term_risk
     
  end  
end
