require "test_helper"

class MapControllerTest < ActionDispatch::IntegrationTest
  test "should get index if user has credits" do
    login_as(users(:oscar))

    get map_url
    assert_response :success
  end

  test "should redirect to no credits page if user has no credits" do
    login_as(users(:finlay))

    get map_url
    assert_redirected_to user_no_credits_url
  end
end
