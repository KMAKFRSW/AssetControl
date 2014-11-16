#encoding: utf-8

class Fxtrade < ActiveRecord::Base
  attr_accessible :commission, :currency, :order_no, :position_no, :price, :quantity, :realized_gain, :sum_gain, :sw_gain, :trade_type, :trade_date, :user_id

  self.table_name = 'fx_trade'
  
  belongs_to :user, dependent: :destroy

  # 属性に対応する日本語名
  REAL_ATTRIBUTE_NAMES = {
    :order_no => '注文番号',
    :trade_date => '約定日',
    :position_no => '建玉番号',
    :currency => '通貨ペア',
    :trade_type => '取引の種類',
    :quantity => '数量',
    :price => '価格',
    :commission => '手数料(¥)',
    :sw_gain => 'Swap(¥)',
    :realized_gain => '損益(¥)',
    :sum_gain => '合計損益(¥)', 
    :updated_at => '更新日付',
    # その他個別
    :trade_num => '決済回数',
    :week => '週'
  }
  
  def self.real_attribute_name(key)
    REAL_ATTRIBUTE_NAMES[key.to_sym]
  end

  # 過去全期間平均
  def self.avg(user_id)
     find_by_sql(["select concat(date_format(max(updated_at),'%Y/%m/%d %H:%i:%s')) as UpdatedDate, count(*) as TradeNum,SUM(sw_gain) as TotalSwapGain, SUM(realized_gain)  as TotalRealizedGain, SUM(realized_gain) + SUM(sw_gain) as TotalGain from fx_trade 
        where fx_trade.trade_type like ? and user_id = ? ", '決済%', user_id])
  end

  # 直近30日損益取得
  def self.last_30_day(user_id)
     find_by_sql(["select date_format(cast(trade_date as date),'%Y/%m/%d') as Date, SUM(sw_gain) as SwapGain_Last30day, SUM(realized_gain) as RealizedGain_Last30day from fx_trade 
        where fx_trade.trade_type like ? and user_id = ? group by Date order by Date desc, currency desc limit 30 ", '決済%', user_id])
  end

  # 直近5週損益取得
  def self.last_5_week(user_id)
     find_by_sql(["select DATE_FORMAT(MAX(trade_date),'%Y/%m/%d') as Date, YEARWEEK(trade_date) as YearWeek, SUM(sw_gain) as SwapGain_Week, SUM(realized_gain)  as RealizedGain_Week from fx_trade
      where fx_trade.trade_type like ?
      and user_id = ?
      group by YearWeek
      order by YearWeek desc
      limit 5", '決済%', user_id])
  end

  # Best10
  def self.best10(user_id)
     find_by_sql(["select date_format(cast(trade_date as date),'%Y/%m/%d') as Date, SUM(sw_gain) as SwapGain_Best10, SUM(realized_gain)  as RealizedGain_Best10 from fx_trade 
        where fx_trade.trade_type like ? 
        and user_id = ?
        group by Date 
        order by RealizedGain_Best10 desc
        limit 10", '決済%', user_id])
  end

  # Worst10
  def self.worst10(user_id)
     find_by_sql(["select date_format(cast(trade_date as date),'%Y/%m/%d') as Date, SUM(sw_gain) as SwapGain_Worst10, SUM(realized_gain)  as RealizedGain_Worst10 from fx_trade 
        where fx_trade.trade_type like ? 
        and user_id = ?
        group by Date 
        order by RealizedGain_Worst10 asc
        limit 10", '決済%', user_id])
  end

  # 日次詳細
  def self.daily_detail(trade_date, user_id)
     find_by_sql(["select trade_date, currency, quantity, price, sw_gain, realized_gain, sum_gain from fx_trade
      where trade_type like ?
      and date_format(trade_date,'%Y/%m/%d') = ?
      and user_id = ?
      order by cast('trade_date' as date) desc", '決済%', trade_date, user_id])
  end
  # 月次損益
  def self.monthly_interest(user_id)
     find_by_sql([" select date_format(trade_date,'%Y/%m') as month, sum(sum_gain) as sum_gain from fx_trade
      where trade_type like ?
      and user_id = ?
      and date_format(trade_date,'%Y/%m') >= date_format(now() - INTERVAL 1 YEAR,'%Y/%m')
      group by date_format(trade_date,'%Y/%m')
      order by trade_date asc", '決済%',  user_id])
  end

  # csv登録機能(注文番号をKEYに新規であればinsertし、既存レコードが存在すればレコードをupdateする）
  def self.load_csv(csv_file, user_id)
    require 'csv'   #csv操作を可能にするライブラリ
    require 'kconv' #文字コード操作をよろしくやるライブラリ
 
    #params[:upfile]にファイルが格納されているので
    #受け取って文字列にする処理
    content = csv_file.read
    parsed = Kconv.toutf8(content)
    parsed = CSV.parse(content.kconv(Kconv::UTF8, Kconv::SJIS), :headers => true) # headerは除く
    
    #  parsedの内容を一行ずつ取り込むorder番号が重複する場合はupdate、そうでない場合はinsert
    parsed.each do |row|

      if Fxtrade.exists?({ :order_no => row[0], :user_id => user_id })
        @fx = Fxtrade.find_by_order_no(row[0])
        @fx.attributes = {
            :trade_date => row[1], 
            :position_no => row[2], 
            :currency => row[3], 
            :trade_type => row[4], 
            :quantity => row[5], 
            :price => row[6], 
            :commission => row[7], 
            :sw_gain => row[8], 
            :realized_gain => row[9], 
            :sum_gain => row[10]
        }
        @fx.save!
      else
        Fxtrade.create!(
            :order_no => row[0], 
            :trade_date => row[1], 
            :position_no => row[2], 
            :currency => row[3], 
            :trade_type => row[4], 
            :quantity => row[5], 
            :price => row[6], 
            :commission => row[7], 
            :sw_gain => row[8], 
            :realized_gain => row[9], 
            :sum_gain => row[10],
            :user_id => user_id
        )
      end
    end
  end
end
