#encoding: utf-8

class Pivot < ActiveRecord::Base
  attr_accessible :P, :R1, :R2, :R3, :S1, :S2, :S3, :calc_date, :cur_code, :cycle
  self.table_name = 'pivots'
  self.primary_keys = :calc_date, :cur_code, :cycle
end
