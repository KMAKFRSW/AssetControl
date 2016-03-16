#encoding: utf-8

require 'date'
include Performance

class Tasks::Calculate_Initial_Data_Performance
  def self.setup
 
    for num in 2..360 do
      # get reference date (format:YYYYMMDD)
      batchdate = (Date.today - num).strftime("%Y%m%d")
      weekday = batchdate.to_date.wday
      if (weekday == 1 || weekday == 2 || weekday == 3 || weekday == 4 || weekday == 5) && batchdate.to_date.strftime("%m%d") != '0101'then  
        
      end
    end
  end
    
    
end
