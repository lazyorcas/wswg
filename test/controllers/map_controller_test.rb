require "test_helper"

class MapControllerTest < ActionDispatch::IntegrationTest
  test "should get index if user has credits" do
    login_as(users(:oscar))

    get map_url
    assert_response :success
  end
end
