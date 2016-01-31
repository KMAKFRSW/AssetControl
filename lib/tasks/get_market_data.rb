#encoding: utf-8

require 'date'
require "#{Rails.root}/app/models/market_data_price"
require "#{Rails.root}/app/models/market_data"
require "#{Rails.root}/lib/tasks/tool/http_client"
require "#{Rails.root}/lib/tasks/tool/acquirer"
require "#{Rails.root}/lib/tasks/tool/universe"

class Tasks::Get_Market_Data
  def self.execute( asset_class, region_code)
    # get target securities
    array_universe, data_date = Universe.get_universe(asset_class, region_code)
    # get recent prices
    array_universe.map do |universe|
      Acquirer.scrape_info(universe, data_date)
    end
  end
end
