#encoding: utf-8

class Rsi < ActiveRecord::Base
  attr_accessible :RSI, :calc_date, :cur_code, :term
  self.table_name = 'rsis'
  self.primary_keys = :calc_date, :cur_code, :term
end
