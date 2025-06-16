require "application_system_test_case"

class Home::EventsTest < ApplicationSystemTestCase
  setup do
    @city = cities(:singapore)
    @event = events(:first)
  end

  test "clicking on event title should create a seen" do
    visit all_city_events_path(event_category_slug: "events", city_slug: @city.slug)
    assert_difference "Seen.count", 1 do
      click_on @event.title
    end
  end

  test "click on more details should create a seen" do
    visit all_city_events_path(event_category_slug: "events", city_slug: @city.slug)
    assert_difference "Seen.count", 1 do
      find("summary", text: "More details").click
    end
  end
end
