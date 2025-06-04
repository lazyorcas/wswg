require "test_helper"

class Map::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    login_as(users(:oscar))

    get map_events_url
    assert_response :success
  end

  test "should get show" do
    login_as(users(:oscar))

    get map_event_url(events(:first))
    assert_response :success
  end
end
