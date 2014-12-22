#encoding: utf-8

class Acquirer

  def self.get_info(array_mkt_attr, data_date)
    array_info = get_universe_price(array_mkt_attr)
    store_price_to_database(array_info, data_date)
  end

  private

    def self.get_universe_price(array_mkt_attr)
      array_mkt_attr.map do |mkt_attr|
        # Judging from vendor_code, get the recent price from each web site
        case mkt_attr.vendor_code
        when '01' then #Yahoo Finance
          scrape_recent_price_from_Yahoo(mkt_attr)
        else
          raise "vendor_code #{mkt_attr.vendor_code} is not defined in this method."
        end
      end
    end

    def self.scrape_recent_price_from_Yahoo(mkt_attr)
      # TODO: ugly..
      url = "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{mkt_attr.security_code}"
      html = HttpClient.get(url)
              
      # get recent prices
      prev_price, open_price, high_price, low_price, volume, high_in_1year, low_in_1year = html.css('div.innerDate dd').map{|x| x.css('strong').inner_text }

      info = {
        code:               mkt_attr.security_code,
        vendor_code:        mkt_attr.vendor_code,
        market_code:        mkt_attr.market_code,
        name:               html.css('table.stocksTable th.symbol h1').inner_text,
        price:              html.css('table.stocksTable td.stoksPrice')[1].content,
        changes:            html.css('td.change span.icoUpGreen').inner_text,
        trade_time:         html.css('dd.yjSb')[1].content,
        prev_price:         prev_price,
        open_price:         open_price,
        high_price:         high_price,
        low_price:          low_price,
        volume:             volume,
        high_in_1year:      high_in_1year, # [caution] 52 weeks in case foreign equity index
        low_in_1year:       low_in_1year,  # [caution] 52 weeks in case foreign equity index
        chart_image:        html.css("div.styleChart img")[0][:src],
      }
    end
    
    def self.store_price_to_database(array_info, data_date)
      # define array for loop 
      arry_item = [
        [:price, Settings[:item_equity][:close_price]],
        [:changes,Settings[:item_equity][:changes]],
        [:prev_price, Settings[:item_equity][:prev_price]],
        [:open_price, Settings[:item_equity][:open_price]],
        [:high_price, Settings[:item_equity][:high_price]],
        [:low_price, Settings[:item_equity][:low_price]],
        [:volume, Settings[:item_equity][:volume]],
        [:high_in_1year, Settings[:item_equity][:high_in_1year]],
        [:low_in_1year, Settings[:item_equity][:low_in_1year]],
        [:trade_time, Settings[:item_equity][:trade_time]],
      ]

      array_info.each do |row|          
        
        code        = row[:code]
        vendor_code = row[:vendor_code]
        market_code = row[:market_code]
       
        arry_item.each do |key, item_code|
          data        = row[key]
          # update database
          if MarketDataPrice.exists?({ :security_code => code, :vendor_code => vendor_code, :market_code => market_code, :trade_date => data_date, :item => item_code })
              @MarketDataPrice = MarketDataPrice.find_by_security_code_and_vendor_code_and_market_code_and_trade_date_and_item(code, vendor_code, market_code, data_date, item_code)
              @MarketDataPrice.attributes = {
                  :data => row[key]
              }
              @MarketDataPrice.save!
          else
            MarketDataPrice.create!(
                :security_code => code, 
                :vendor_code => vendor_code,
                :market_code => market_code, 
                :trade_date => data_date, 
                :item => item_code,
                :data => row[key]
                )
          end
        end
      end
    end    
end
