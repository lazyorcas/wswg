require "test_helper"

class Events::BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:oscar))
  end

  test "should get index" do
    get bookmarks_url
    assert_response :success
  end
end
