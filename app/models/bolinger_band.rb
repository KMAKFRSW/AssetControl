#encoding: utf-8

class BolingerBand < ActiveRecord::Base
  attr_accessible :MA, :calc_date, :cur_code, :minus1sigma, :minus2sigma, :minus3sigma, :plus1sigma, :plus2sigma, :plus3sigma, :term
  self.table_name = 'bolinger_bands'
  self.primary_keys = :calc_date, :cur_code, :term
end
