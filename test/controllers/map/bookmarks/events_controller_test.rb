require "test_helper"

class Map::Bookmarks::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:oscar))
  end

  test "should get index" do
    get map_bookmarked_events_url
    assert_response :success
  end
end
