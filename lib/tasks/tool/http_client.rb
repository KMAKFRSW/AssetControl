#encoding: utf-8

require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'

module HttpClient
  def self.get(url)
    begin
      html = open(url, :allow_redirections => :safe).read
    rescue URI::InvalidURIError
      url = URI.encode(url)
      html = open(url, "Accept-Encoding" => "utf-8")
    rescue Zlib::DataError
      html = open(url, "Accept-Encoding" => "utf-8")
    end
    Nokogiri::HTML(html, url)
  end
end
