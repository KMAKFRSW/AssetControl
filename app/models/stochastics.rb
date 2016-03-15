#encoding: utf-8

class Stochastics < ActiveRecord::Base
  attr_accessible :D, :K, :SD, :calc_date, :cur_code, :dterm, :kterm
  self.table_name = 'stochastics'
  self.primary_keys = :calc_date, :cur_code, :kterm, :dterm
end
