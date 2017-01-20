# config: UTF-8

require 'spec_helper'
require 'zipcloud'

describe Zipcloud do
    context "When ZipCloud URL return 200" do
        @expected

        before {
            body_str = 
'{
    "message": null,
    "results": [
        {
            "address1": "東京都",
            "address2": "千代田区",
            "address3": "",
            "kana1": "ﾄｳｷｮｳﾄ",
            "kana2": "ﾁﾖﾀﾞｸ",
            "kana3": "",
            "prefcode": "13",
            "zipcode": "1000000"
        }
    ],
    "status": 200
}'

            stub_request(:get, Zipcloud::ZipCloud_URL + "/api/search?zipcode=1000000")
                .to_return(status: 200, body: body_str)

            jsonBody = JSON.parse(body_str)
            @expected = jsonBody['results'].collect do |dat|
              Zipcloud::PostalAddress.new dat
            end
        }

        it "should get PostalAddress class" do
                actual = "1000000".to_postal_addresses

                expect(actual.length).to be(1)
                expect(actual[0].address1).to eq(@expected[0].address1)
                expect(actual[0].address2).to eq(@expected[0].address2)
                expect(actual[0].address3).to eq(@expected[0].address3)
                expect(actual[0].kana1).to eq(@expected[0].kana1)
                expect(actual[0].kana2).to eq(@expected[0].kana2)
                expect(actual[0].kana3).to eq(@expected[0].kana3)
                expect(actual[0].zipcode).to eq(@expected[0].zipcode)
                expect(actual[0].prefcode).to eq(@expected[0].prefcode)
        end
    end

    context "When ZipCloud return error" do
        context "with time out" do
            before {
                stub_request(:get, Zipcloud::ZipCloud_URL + "/api/search?zipcode=invalid")
                    .to_timeout
            }

            it "should raise OpenTimeout exception" do
                expect {
                    "invalid".to_postal_addresses
                    }.to raise_error(Net::OpenTimeout)
            end
        end

        context "with BadRequest" do
            before {
                stub_request(:get, Zipcloud::ZipCloud_URL + "/api/search?zipcode=invalid")
                    .to_return(
                        status: 400,
                        body: 
'{
    "message": "test error",
    "results": null,
    "status": 400
}'
                        )
            }

            it "should raise RuntimeError" do
                expect {
                    "invalid".to_postal_addresses
                    }.to raise_error('ERROR CODE:400 test error')
            end
        end

        context "with Internal Server Error" do
            before {
                stub_request(:get, Zipcloud::ZipCloud_URL + "/api/search?zipcode=1000000")
                    .to_return(
                        status: 500,
                        body:
'{
    "message": "test error",
    "results": null,
    "status": 500
}'
                        )
            }

            it "should raise RuntimeError" do
                expect {
                    "1000000".to_postal_addresses
                    }.to raise_error('ERROR CODE:500 test error')
            end
        end
    end
end