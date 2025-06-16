require "application_controller_test_case"

class HomeControllerTest < ApplicationControllerTestCase
  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get pricing" do
    get pricing_url
    assert_response :success
  end

  test "should get local events directory" do
    get local_events_directory_url
    assert_response :success
  end

  test "every city_events url" do
    City.all.each do |city|
      EventCategory::SYMBOLS.each do |event_category_symbol|
        TimePeriod::SYMBOLS.each do |time_period_symbol|
          if time_period_symbol == :all
            get all_city_events_url(city_slug: city.slug, event_category_slug: EventCategory::SYMBOL_TO_SLUG_MAPPING[event_category_symbol])
          else
            get city_events_url(city_slug: city.slug, event_category_slug: EventCategory::SYMBOL_TO_SLUG_MAPPING[event_category_symbol], time_period_slug: TimePeriod.slugify(time_period_symbol))
          end
          assert_response :success
          assert_select "h1", text: /#{city.name}/
        end
      end
    end
  end

  test "every nearby_events url" do
    headers = build_human_headers

    EventCategory::SYMBOLS.each do |event_category_symbol|
      TimePeriod::SYMBOLS.each do |time_period_symbol|
        if time_period_symbol == :all
          get all_nearby_events_url(event_category_slug: EventCategory::SYMBOL_TO_SLUG_MAPPING[event_category_symbol]), headers: headers
        else
          get nearby_events_url(event_category_slug: EventCategory::SYMBOL_TO_SLUG_MAPPING[event_category_symbol], time_period_slug: TimePeriod.slugify(time_period_symbol)), headers: headers
        end
        assert_response :success
      end
    end
  end

  test "visitor should generate a visit" do
    headers = build_human_headers

    assert_difference "Ahoy::Visit.count", 1 do
      get root_url, headers: headers
    end
  end

  test "bot should not generate a visit" do
    headers = build_bot_headers

    assert_difference "Ahoy::Visit.count", 0 do
      get root_url, headers: headers
    end
  end
end
