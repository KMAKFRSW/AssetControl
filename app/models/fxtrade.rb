#encoding: utf-8

class Fxtrade < ActiveRecord::Base
  attr_accessible :commission, :currency, :order_no, :position_no, :price, :quantity, :realized_gain, :sum_gain, :sw_gain, :trade_type, :trade_date, :user_id

  self.table_name = 'fx_trade'
  
  belongs_to :user, dependent: :destroy

  # define the name of attributes
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
    :trade_num => '決済回数',
    :week => '週',
    :winning_percentage => '勝率'
  }
  
  def self.real_attribute_name(key)
    REAL_ATTRIBUTE_NAMES[key.to_sym]
  end

  # get the last total summary
  def self.avg(user_id)
     # get the score of trade for last 30 days
        find_by_sql(["select concat(date_format(max(updated_at),'%Y/%m/%d %H:%i:%s')) as UpdatedDate, count(*) as TradeNum,SUM(sw_gain) as TotalSwapGain, SUM(realized_gain)  as TotalRealizedGain, SUM(realized_gain) + SUM(sw_gain) as TotalGain from fx_trade 
        where fx_trade.trade_type like ? and user_id = ? ", '決済%', user_id])
  end

  # last 30 days
  def self.last_30_day(user_id)
        find_by_sql(["select A.Date, A.SwapGain_Last30day, A.RealizedGain_Last30day, B.WinningPercentage from (
              select date_format(cast(trade_date as date),'%Y/%m/%d') as Date, SUM(sw_gain) as SwapGain_Last30day, SUM(realized_gain) as RealizedGain_Last30day from fx_trade 
              where fx_trade.trade_type like ? and user_id = ? group by Date order by Date desc limit 30
              ) A LEFT JOIN (
              select Y.Date as Date, Case when X.WinningTradeNum > 0 then round(X.WinningTradeNum/Y.TortalTradeNum*100, 2) when X.WinningTradeNum is NULL then 0 end as WinningPercentage from (
                select date_format(cast(trade_date as date),'%Y/%m/%d') as Date, count(*) as WinningTradeNum from fx_trade 
                  where fx_trade.trade_type like  ? and user_id =  ? and sum_gain >= 0 group by Date order by Date desc limit 30
                  ) X RIGHT JOIN (
                  select date_format(cast(trade_date as date),'%Y/%m/%d') as Date, count(*) as TortalTradeNum from fx_trade 
                  where fx_trade.trade_type like  ? and user_id =  ? group by Date order by Date desc limit 30
                  ) Y
              ON X.Date = Y.Date 
              limit 30 
              ) B
              ON A.Date = B.Date
              order by A.Date desc
              ", '決済%', user_id, '決済%', user_id, '決済%', user_id])
  end

  # last 5 week
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

  # summary of daily trade
  def self.daily_detail(trade_date, user_id)
     find_by_sql(["select trade_date, currency, quantity, trade_type, price, sw_gain, realized_gain, sum_gain from fx_trade
      where trade_type like ?
      and date_format(trade_date,'%Y/%m/%d') = ?
      and user_id = ?
      order by trade_date asc", '決済%', trade_date, user_id])
  end
  
  # get monthly interest
  def self.monthly_interest(user_id)
     find_by_sql([" select date_format(trade_date,'%Y/%m') as month, sum(sum_gain) as sum_gain from fx_trade
      where trade_type like ?
      and user_id = ?
      and date_format(trade_date,'%Y/%m') >= date_format(now() - INTERVAL 1 YEAR,'%Y/%m')
      group by date_format(trade_date,'%Y/%m')
      order by trade_date asc", '決済%',  user_id])
  end

  # csv upload
  def self.load_csv(csv_file, user_id)
    require 'csv'   # library for editing csv file
    require 'kconv' # library for changing encoding
     
    # extract the contents of csv file from params[:upfile]
    content = csv_file.read
    parsed = Kconv.toutf8(content)
    # exclude header
    parsed = CSV.parse(content.kconv(Kconv::UTF8, Kconv::SJIS), :headers => true) 
    
    # update databases
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
