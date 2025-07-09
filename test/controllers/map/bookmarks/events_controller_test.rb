require "test_helper"

class Map::BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:oscar))
  end

  test "should get index" do
    get map_bookmarks_url
    assert_response :success
  end
end
