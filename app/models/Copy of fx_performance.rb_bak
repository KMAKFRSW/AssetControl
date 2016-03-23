#encoding: utf-8

class FxPerformance < ActiveRecord::Base
  attr_accessible :calc_date, :cur_code, :data, :item

  self.table_name = 'fx_performances'
  self.primary_keys = :calc_date, :cur_code, :item


  def self.get_daily_range()
      
     usdjpy_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'USD/JPY', 'RNG01'])
       
     eurjpy_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'EUR/JPY', 'RNG01'])
       
     eurusd_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'EUR/USD', 'RNG01'])
       
     audjpy_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'AUD/JPY', 'RNG01'])
       
     audusd_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'AUD/USD', 'RNG01'])
       
     gbpjpy_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'GBP/JPY', 'RNG01'])
       
     gbpusd_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", 'GBP/USD', 'RNG01'])
       
       return usdjpy_range, eurjpy_range, eurusd_range, audjpy_range, audusd_range, gbpjpy_range, gbpusd_range 
     
  end
  
  def self.get_term_risk()
     usdjpy_term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'USD/JPY', 'RSK%'])

     eurjpy_term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/JPY', 'RSK%'])

     usdeur_term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/USD', 'RSK%'])

     audjpy_term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'AUD/JPY', 'RSK%'])

     audusd_term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'AUD/USD', 'RSK%'])

     gbpjpy_term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'GBP/JPY', 'RSK%'])

     gbpusd_term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'GBP/USD', 'RSK%'])

       return usdjpy_term_risk, eurjpy_term_risk, usdeur_term_risk, audjpy_term_risk, audusd_term_risk, gbpjpy_term_risk, gbpusd_term_risk
     
  end

  def self.get_avg_daily_range()
      
     usdjpy_avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'USD/JPY', 'AVG0%'])
       
     eurjpy_avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/JPY', 'AVG0%'])
       
     eurusd_avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/USD', 'AVG0%'])
       
     audjpy_avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'AUD/JPY', 'AVG0%'])
       
     audusd_avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'AUD/USD', 'AVG0%'])
       
     gbpjpy_avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'GBP/JPY', 'AVG0%'])
       
     gbpusd_avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'GBP/USD', 'AVG0%'])
       
       return usdjpy_avg_range, eurjpy_avg_range, eurusd_avg_range, audjpy_avg_range, audusd_avg_range, gbpjpy_avg_range, gbpusd_avg_range 
     
  end
  
  def self.get_avg_daily_rate()
      
     usdjpy_avg_rate = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'USD/JPY', 'AVG1%'])
       
     eurjpy_avg_rate = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/JPY', 'AVG1%'])
       
     eurusd_avg_rate = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'EUR/USD', 'AVG1%'])
       
     audjpy_avg_rate = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'AUD/JPY', 'AVG1%'])
       
     audusd_avg_rate = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'AUD/USD', 'AVG1%'])
       
     gbpjpy_avg_rate = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'GBP/JPY', 'AVG1%'])
       
     gbpusd_avg_rate = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", 'GBP/USD', 'AVG1%'])
       
       return usdjpy_avg_rate, eurjpy_avg_rate, eurusd_avg_rate, audjpy_avg_rate, audusd_avg_rate, audjpy_avg_rate, audusd_avg_rate 
     
  end
  
  def self.get_daily_pivot()    
     daily_pivot = find_by_sql(["select date_format(calc_date,?) as calc_date, cur_code, S3, S2, S1, P, R1, R2, R3 from pivots
       where calc_date = (select max(calc_date) as calc_date from pivots)
       order by cur_code asc","%Y/%m/%d"])
       
       return daily_pivot
  end
  
  def self.get_technical_data()    
     technical_data = find_by_sql(["select date_format(BB.calc_date,?) as calc_date, BB.cur_code, BB.minus3sigma, BB.minus2sigma, BB.minus1sigma, BB.MA, BB.plus1sigma, BB.plus2sigma, BB.plus3sigma, DFMA5.DFMA as DFMA5, DFMA25.DFMA as DFMA25, RSI.RSI, ST.K, ST.D from (
        select * from bolinger_bands
        where calc_date >= (date_format( now() - INTERVAL 1 MONTH,'%Y%m%d'))
        and term = '25'
        order by cur_code, calc_date
        ) BB,(
        select * from difference_from_mas
        where calc_date >= date_format( now() - INTERVAL 1 MONTH,'%Y%m%d')
        and term = '5'
        order by cur_code, calc_date
        ) DFMA5,(
        select * from difference_from_mas
        where calc_date >= date_format( now() - INTERVAL 1 MONTH,'%Y%m%d')
        and term = '25'
        order by cur_code, calc_date
        ) DFMA25,(
        select * from rsis
        where calc_date >= date_format( now() - INTERVAL 1 MONTH,'%Y%m%d')
        and term = '14'
        order by cur_code, calc_date
        ) RSI,(
        select * from stochastics
        where calc_date >= date_format( now() - INTERVAL 1 MONTH,'%Y%m%d')
        and kterm = '14'
        and dterm = '3'
        order by cur_code, calc_date
        ) ST
      where BB.cur_code = DFMA5.cur_code
      and BB.cur_code = DFMA25.cur_code
      and BB.cur_code = RSI.cur_code
      and BB.cur_code = ST.cur_code
      and BB.calc_date = (select max(calc_date) from bolinger_bands)
      and BB.calc_date = DFMA5.calc_date
      and BB.calc_date = DFMA25.calc_date
      and BB.calc_date = RSI.calc_date
      and BB.calc_date = ST.calc_date
      order by BB.calc_date desc, BB.cur_code","%Y/%m/%d"])
       
       return technical_data
  end
  
end
