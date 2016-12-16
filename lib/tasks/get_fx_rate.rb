#encoding: utf-8

require 'open-uri'
require 'date'
require 'kconv' 
require 'csv' 
require "#{Rails.root}/app/models/fx_rate" 

class Tasks::Get_Fx_Rate
  def self.execute
    for num in 2..10 do
    # Get yesterday'date
    yesterday = (Date.today - num).strftime("%Y%m%d")
        
    # set url
    url = 'https://www.tfx.co.jp/kawase/document/PRT-010-CSV-003-'+ yesterday +'.CSV'
    
    # get file name
    filename = url.split(/\//).last
    
    # access to url & get the contens file & update table
    # 【improvement】need to check if the object of file is null 
    
    begin
      open(url) do |source|
        parsed = CSV.parse((source.read).kconv(Kconv::UTF8, Kconv::SJIS), :headers => true )
        # loop that read rows from file & update table
        parsed.each do |row|
          if row[0] == "D01"   # D01 means header or footer
            if FxRate.exists?({ :data_kbn => row[0], :trade_date => row[1], :product_code1 => row[2], :product_code2 => row[3] })
              @fx = FxRate.find_by_data_kbn_and_trade_date_and_product_code1_and_product_code2(row[0], row[1], row[2], row[3])
              @fx.attributes = {
                  :product_name => row[4], 
                  :prev_price => row[5], 
                  :open_price => row[6], 
                  :open_price_time => row[7], 
                  :high_price => row[8], 
                  :high_price_time => row[9], 
                  :low_price => row[10], 
                  :low_price_time => row[11], 
                  :close_price => row[12], 
                  :close_price_time => row[13], 
                  :today_price => row[14], 
                  :prev_changes => row[15], 
                  :swap => row[16], 
                  :trade_quantity => row[17],
                  :position_quantity => row[18]
              }
              @fx.save!
            else
              FxRate.create!(
                  :data_kbn => row[0], 
                  :trade_date => row[1], 
                  :product_code1 => row[2], 
                  :product_code2 => row[3], 
                  :product_name => row[4], 
                  :prev_price => row[5], 
                  :open_price => row[6], 
                  :open_price_time => row[7], 
                  :high_price => row[8], 
                  :high_price_time => row[9], 
                  :low_price => row[10], 
                  :low_price_time => row[11], 
                  :close_price => row[12], 
                  :close_price_time => row[13], 
                  :today_price => row[14], 
                  :prev_changes => row[15], 
                  :swap => row[16], 
                  :trade_quantity => row[17],
                  :position_quantity => row[18]
                  )
            end
          end
        end
      end
    rescue
      puts("retry")
      sleep 600
      retry
    end
    end
  end
end