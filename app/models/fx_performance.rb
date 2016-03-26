#encoding: utf-8

class FxPerformance < ActiveRecord::Base
  attr_accessible :calc_date, :cur_code, :data, :item

  self.table_name = 'fx_performances'
  self.primary_keys = :calc_date, :cur_code, :item


  def self.get_daily_range(cur_code)
      
     range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item = ?
       order by date asc, item asc
       ", cur_code, 'RNG01'])
       
       return range 
     
  end
  
  def self.get_term_risk(cur_code)
     term_risk = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", cur_code, 'RSK%'])
       
       return term_risk
     
  end

  def self.get_avg_daily_range(cur_code)
      
     avg_range = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", cur_code, 'AVG0%'])

       return avg_range 
     
  end
  
  def self.get_avg_daily_rate(cur_code)
      
     avg_rate_day = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, item, data from fx_performances
       where calc_date > date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
       and cur_code = ?
       and item like ?
       order by date asc, item asc
       ", cur_code, 'AVG1%'])
       
       return avg_rate_day      
  end

  def self.get_dfma(cur_code)
      
     avg_rate_day = find_by_sql(["select date_format(DFMA5.calc_date, '%Y/%m/%d') as date , DFMA5.cur_code, DFMA5.DFMA as DFMA5, DFMA25.DFMA as DFMA25 from (
          select * from difference_from_mas
          where calc_date >= date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
          and cur_code = ?
          and term = '5'
          ) DFMA5,(
          select * from difference_from_mas
          where calc_date >= date_format( now() - INTERVAL 1 YEAR,'%Y%m%d')
          and cur_code = ?
          and term = '25'
          ) DFMA25
        where DFMA5.cur_code = DFMA25.cur_code
        and DFMA5.calc_date = DFMA25.calc_date
        order by date asc
       ", cur_code, cur_code])
       
       return avg_rate_day      
  end
  
  def self.get_daily_pivot()
     daily_pivot = find_by_sql(["select date_format(calc_date,?) as calc_date, cur_code, S3, S2, S1, P, R1, R2, R3 from pivots
       where calc_date = (select max(calc_date) as calc_date from pivots)
       order by cur_code asc","%Y/%m/%d"])
       
       return daily_pivot
  end
  
  def self.get_bolinger_band()    
     bolinger_band = find_by_sql(["select date_format(BB.calc_date,?) as calc_date, BB.cur_code, BB.minus3sigma, BB.minus2sigma, BB.minus1sigma, BB.MA, BB.plus1sigma, BB.plus2sigma, BB.plus3sigma from (
        select * from bolinger_bands
        where calc_date >= (date_format( now() - INTERVAL 1 MONTH,'%Y%m%d'))
        and term = '25'
        order by cur_code, calc_date
        ) BB
      where BB.calc_date = (select max(calc_date) from bolinger_bands)
      order by BB.calc_date desc, BB.cur_code","%Y/%m/%d"])
       
       return bolinger_band
  end

  def self.get_rsi_and_st(cur_code)
     rsi_and_st = find_by_sql(["select date_format(RSI.calc_date,?) as date, RSI.cur_code, RSI.RSI, ST.K*100 as K, ST.D*100 as D from (
        select * from rsis
        where calc_date >= date_format( now() - INTERVAL 2 MONTH,'%Y%m%d')
        and cur_code = ?
        and term = '14'
        ) RSI,(
        select * from stochastics
        where calc_date >= date_format( now() - INTERVAL 2 MONTH,'%Y%m%d')
        and cur_code = ?
        and kterm = '14'
        and dterm = '3'
        ) ST
      where ST.cur_code = RSI.cur_code
      and RSI.calc_date = ST.calc_date
      order by RSI.calc_date asc","%Y/%m/%d", cur_code, cur_code])
       
       return rsi_and_st
       
  end
  
end
