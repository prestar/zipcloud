require "zipcloud/version"
require "net/http"
require "json"

class String
  include Zipcloud
end

module Zipcloud
  ZipCloud_URL = "zipcloud.ibsnet.co.jp"

  def to_postal_addresses
    data = JSON.parse(send_to_zipcloud self)

    error? data

    data["results"].collect do |dat|
      PostalAddress.new dat
    end
  end

  class PostalAddress
    attr_reader :address1, :address2, :address3
    attr_reader :kana1, :kana2, :kana3, :zipcode, :prefcode

    def initialize zipcloud_results
      @address1 = zipcloud_results["address1"]
      @address2 = zipcloud_results["address2"]
      @address3 = zipcloud_results["address3"]

      @kana1 = zipcloud_results["kana1"]
      @kana2 = zipcloud_results["kana2"]
      @kana3 = zipcloud_results["kana3"]

      @zipcode = zipcloud_results["zipcode"]
      @prefcode = zipcloud_results["prefcode"]
    end
  end

  private
  def send_to_zipcloud zipcode
    response = Net::HTTP.new(ZipCloud_URL, 80).start do |svr|
      svr.get("/api/search?" + "zipcode=" + zipcode)
    end

    response.body
  end

  def error? data
    return false if data["status"] == 200

    raise "ERROR CODE:#{data["status"]} #{data["message"]}"
    return true
  end
end
