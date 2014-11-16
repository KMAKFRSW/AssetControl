#encoding: utf-8

require 'open-uri'
require 'date'
require 'kconv' #文字コード操作をよろしくやるライブラリ
require 'csv' #文字コード操作をよろしくやるライブラリ
require "#{Rails.root}/app/models/fx_rate" # ActiveRecordを使用する

class Tasks::Get_Fx_Rate
  def self.execute
    # 前日日付(YYYYMMDD)を取得する
    yesterday = (Date.today - 1).strftime("%Y%m%d")
    
    #http getするurlを作成
    url = 'http://www.tfx.co.jp/kawase/document/PRT-010-CSV-003-'+ yesterday +'.CSV'
    
    # ファイルネームを抽出(Log出力用)
    filename = url.split(/\//).last
    
    # urlをopenしてファイル内容を変数に格納、parseしてmodel更新
    # ★ファイルが取れているかオブジェクトに対するnilチェックが必要
    open(url) do |source|
      parsed = CSV.parse((source.read).kconv(Kconv::UTF8, Kconv::SJIS), :headers => true )
      #  parsedの内容を一行ずつ吟味し、更新する
      parsed.each do |row|
        if row[0] == "D01"   #header, footerは取り込まないようにデータ区分で判断する
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
  end
end