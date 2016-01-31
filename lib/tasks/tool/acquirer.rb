#encoding: utf-8

class Acquirer

  def self.scrape_info(universe, data_date)
    array_scrape_info = scrape_vendor_price(universe)
    store_info_to_database(array_scrape_info, data_date)
  end

  def self.scrape_for_alert_rate(universe)
    array_scrape_info = scrape_vendor_price(universe)
    return array_scrape_info
  end

  private

    def self.scrape_vendor_price(universe)
      # Judging from vendor_code and asset class, get the recent price from each sources
      case universe.vendor_code
      when '01' then #Yahoo Finance
        case universe.asset_class
        when 'IX' # Index
          scrape_index_price_from_Yahoo(universe)
        when 'BD' # Bond
          scrape_bond_price_from_Yahoo(universe)
        when 'FX' # FX
          scrape_fx_price_from_Yahoo(universe)
        end
      else
        raise "vendor_code #{universe.vendor_code} is not defined in this method."
      end
    end

    def self.scrape_index_price_from_Yahoo(universe)
      # TODO: ugly..
      url = "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{universe.security_code}"
      html = HttpClient.get(url)
              
      # get recent prices
      prev_price, open_price, high_price, low_price, volume, high_in_1year, low_in_1year = html.css('div.innerDate dd').map{|x| x.css('strong').inner_text }

      array_scrape_info = {
        code:               universe.security_code,
        vendor_code:        universe.vendor_code,
        market_code:        universe.market_code,
        name:               html.css('table.stocksTable th.symbol h1').inner_text,
        price:              html.css('table.stocksTable td.stoksPrice')[1].content,
        changes:            html.css('td.change').inner_text,
        trade_time:         html.css('dd.yjSb')[1].content,
        prev_price:         prev_price,
        open_price:         open_price,
        high_price:         high_price,
        low_price:          low_price,
        volume:             volume,
        high_in_1year:      high_in_1year,    # [caution] 52 weeks in case of foreign equity index
        low_in_1year:       low_in_1year,     # [caution] 52 weeks in case of foreign equity index
        chart_image:        html.css("div.styleChart img")[0][:src],
      }
    end
    
    def self.scrape_bond_price_from_Yahoo(universe)
      # TODO: ugly..
      url = "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{universe.security_code}"
      html = HttpClient.get(url)
              
      # get recent prices
      prev_price, open_price, high_price, low_price, volume, high_in_1year, low_in_1year = html.css('div.innerDate dd').map{|x| x.css('strong').inner_text }

      array_scrape_info = {
        code:               universe.security_code,
        vendor_code:        universe.vendor_code,
        market_code:        universe.market_code,
        name:               html.css('table.stocksTable th.symbol h1').inner_text,
        price:              html.css('table.stocksTable td.stoksPrice')[1].content,
        changes:            html.css('span.icoDownRed').inner_text,
        trade_time:         html.css('dd.yjSb')[1].content,
        prev_price:         prev_price,
        open_price:         open_price,
        high_price:         high_price,
        low_price:          low_price,
        volume:             volume,
        high_in_1year:      high_in_1year,    # [caution] 52 weeks in case of foreign equity index
        low_in_1year:       low_in_1year,     # [caution] 52 weeks in case of foreign equity index
        chart_image:        html.css("div.styleChart img")[0][:src],
      }
    end
    
    def self.scrape_fx_price_from_Yahoo(universe)
      # TODO: ugly..
      url = "http://info.finance.yahoo.co.jp/fx/detail/?code=#{universe.security_code}=FX"
      html = HttpClient.get(url)
              
      # get recent prices
      prev_price, open_price, high_price, low_price, volume, high_in_1year, low_in_1year = html.css('div.innerDate dd').map{|x| x.css('strong').inner_text }

      array_scrape_info = {
        code:               universe.security_code,
        ask_price:          html.css('li.ask dd').inner_text,
        bid_price:          html.css('li.bid dd').inner_text,
      }
    end

    
    def self.store_info_to_database(array_scrape_info, data_date)
      # define array for loop 
      array_item = [
        [:price, Settings[:item_price][:close_price]],
        [:changes,Settings[:item_price][:changes]],
        [:prev_price, Settings[:item_price][:prev_price]],
        [:open_price, Settings[:item_price][:open_price]],
        [:high_price, Settings[:item_price][:high_price]],
        [:low_price, Settings[:item_price][:low_price]],
        [:volume, Settings[:item_price][:volume]],
#        [:high_in_1year, Settings[:item_price][:high_in_1year]],
#        [:low_in_1year, Settings[:item_price][:low_in_1year]],
        [:trade_time, Settings[:item_price][:trade_time]],
      ]

      array_scrape_info.each do |row|
        
        code        = row[:code]
        vendor_code = row[:vendor_code]
        market_code = row[:market_code]
       
        array_item.each do |key, item_code|
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
