#encoding: utf-8

class DifferenceFromMa < ActiveRecord::Base
  attr_accessible :DFMA, :calc_date, :cur_code, :term
  self.table_name = 'difference_from_mas'
  self.primary_keys = :calc_date, :cur_code, :term
end
