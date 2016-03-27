#encoding: utf-8

class BolingerBand < ActiveRecord::Base
  attr_accessible :MA, :calc_date, :cur_code, :minus1sigma, :minus2sigma, :minus3sigma, :plus1sigma, :plus2sigma, :plus3sigma, :term
  self.table_name = 'bolinger_bands'
  self.primary_keys = :calc_date, :cur_code, :term
  
  def self.get_daily_bb(cur_code)
      
     daily_bb = find_by_sql(["select date_format(calc_date, '%Y/%m/%d') as date, cur_code, term, MA, plus1sigma, plus2sigma, plus3sigma, minus1sigma, minus2sigma, minus3sigma from bolinger_bands
       where calc_date > date_format( now() - INTERVAL 2 YEAR,'%Y%m%d')
       and cur_code = ?
       order by date asc
       ", cur_code])

       return daily_bb 
     
  end
    
end
