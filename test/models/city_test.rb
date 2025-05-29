require "test_helper"

class CityTest < ActiveSupport::TestCase
  test "should create city" do
    assert City.create!(
      name: "San Francisco",
      country_code: "US",
      time_zone: "America/Los_Angeles",
      lat: 34.052235,
      lon: -118.243683
    )
  end
end
