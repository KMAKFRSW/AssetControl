#encoding: utf-8

class FxPerformance < ActiveRecord::Base
  attr_accessible :calc_date, :cur_code, :data, :item

  self.table_name = 'fx_performances'
  self.primary_keys = :calc_date, :cur_code, :item

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
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'USD/JPY', 'RSK%'])

     eurjpy_term_risk = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/JPY', 'RSK%'])

     usdeur_term_risk = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/USD', 'RSK%'])

       return usdjpy_term_risk, eurjpy_term_risk, usdeur_term_risk
     
  end

  def self.get_avg_daily_range()
      
     usdjpy_avg_range = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'USD/JPY', 'AVG0%'])
       
     eurjpy_avg_range = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/JPY', 'AVG0%'])
       
     eurusd_avg_range = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/USD', 'AVG0%'])
       
       return usdjpy_avg_range, eurjpy_avg_range, eurusd_avg_range 
     
  end
  
  def self.get_avg_daily_rate()
      
     usdjpy_avg_rate = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'USD/JPY', 'AVG1%'])
       
     eurjpy_avg_rate = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/JPY', 'AVG1%'])
       
     eurusd_avg_rate = find_by_sql(["select date_format(calc_date, '%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/USD', 'AVG1%'])
       
       return usdjpy_avg_rate, eurjpy_avg_rate, eurusd_avg_rate 
     
  end
  
end
