require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get pricing" do
    get pricing_url
    assert_response :success
  end

  test "every city_events url" do
    City.all.each do |city|
      TimePeriod::SYMBOLS.each do |time_period_symbol|
        if time_period_symbol == :all
          get all_city_events_url(city_slug: city.slug)
        else
          get city_events_url(city_slug: city.slug, time_period_slug: TimePeriod.slugify(time_period_symbol))
        end
        assert_response :success
      end
    end
  end

  test "every nearby_events url" do
    TimePeriod::SYMBOLS.each do |time_period_symbol|
      if time_period_symbol == :all
        get all_nearby_events_url
      else
        get nearby_events_url(time_period_slug: TimePeriod.slugify(time_period_symbol))
      end
      assert_response :success
    end
  end
end
