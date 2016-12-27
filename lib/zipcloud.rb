require "zipcloud/version"
require "net/http"
require "json"

module Zipcloud
  ZipCloud_URL = "zipcloud.ibsnet.co.jp"

  def self.to_postal_addresses zipcode
    data = JSON.parse(send_to_zipcloud zipcode)

    data["results"].collect do |dat|
      PostalAddress.new dat
    end
  end

  class PostalAddress
    attr_reader :state, :city, :town, :state_kana, :city_kana, :town_kana, :zipcode, :prefcode
    def initialize zipcloud_results
      @state = zipcloud_results["address1"]
      @city = zipcloud_results["address2"]
      @town = zipcloud_results["address3"]

      @state_kana = zipcloud_results["kana1"]
      @city_kana = zipcloud_results["kana2"]
      @town_kana = zipcloud_results["kana3"]

      @zipcode = zipcloud_results["zipcode"]
      @prefcode = zipcloud_results["prefcode"]
    end
  end

  def self.send_to_zipcloud zipcode
    response = Net::HTTP.new(ZipCloud_URL, 80).start do |svr|
      svr.get("/api/search?" + "zipcode=" + zipcode)
    end

    response.body
  end
end
