require 'test_helper'

class CountryTest < ActiveSupport::TestCase

	def setup
		WebMock.disable!
	end

	test "search for japan should return at least one record" do
		records = Country.find_by_name("japan")
		assert_not_empty records, "Search for Japan should return at least one record"
	end

	test "search for tokyo should return no record" do
		records = Country.find_by_name("tokyo")
		assert_empty records, "Search for Tokyo should return empty array"
	end

	test "Exception handle 404 for search for japan" do
		WebMock.enable!

		stub_get = stub_request(:get, "http://restcountries.eu/rest/v2/name/japan?fullText=true").
		with(headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
		to_return(status: [404, "Not Found"])
		
		records = Country.find_by_name("japan")
		assert_empty records, "For REST API return 404, model should return empty array instead of crashing"

		remove_request_stub(stub_get)
	end

	test "Exception handle 500 for search for japan" do
		WebMock.enable!

		stub_get = stub_request(:get, "http://restcountries.eu/rest/v2/name/japan?fullText=true").
		with(headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
		to_return(status: [500, "Internal Server Error"])
		
		records = Country.find_by_name("japan")
		assert_empty records, "For REST API return 404, model should return empty array instead of crashing"

		remove_request_stub(stub_get)
	end
end
