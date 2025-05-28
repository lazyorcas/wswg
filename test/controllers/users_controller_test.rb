require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference "User.count" do
      post users_url, params: { user: { email: "test@example.com", city_id: cities(:singapore).id, terms_of_service_and_privacy_policy_accepted: "1", notification_frequency: "daily" } }
    end
  end

  test "should create user with bookmark" do
    assert_difference "User.count" do
      post users_url, params: { user: { email: "test@example.com", city_id: cities(:singapore).id, terms_of_service_and_privacy_policy_accepted: "1", bookmarks_attributes: { 0 => { event_id: events(:first).id } } } }
    end

    user = User.last
    assert_equal events(:first).id, user.bookmarks.first.event_id
  end

  test "should create user with search query" do
    assert_difference "User.count" do
      post users_url, params: { user: { email: "test@example.com", city_id: cities(:singapore).id, terms_of_service_and_privacy_policy_accepted: "1", search_queries_attributes: { 0 => { query: "test" } } } }
    end

    user = User.last
    assert_equal "test", user.search_queries.first.query
  end

  test "should redirect to login page after creating user" do
    email = "test@example.com"
    post users_url, params: { user: { email: email, city_id: cities(:singapore).id, terms_of_service_and_privacy_policy_accepted: "1" } }
    assert_redirected_to(login_path(email: email))
  end

  test "should not create user if city is not selected" do
    assert_no_difference "User.count" do
      post users_url, params: { user: { email: "test@example.com" } }
    end
  end

  test "should not create user if city is not found" do
    assert_no_difference "User.count" do
      post users_url, params: { user: { email: "test@example.com", city_id: "not-a-city" } }
    end
  end

  test "should not create user if email is already taken" do
    assert_no_difference "User.count" do
      post users_url, params: { user: { email: users(:oscar).email, city_id: cities(:singapore).id } }
    end
  end

  test "should not create user if email is not valid" do
    assert_no_difference "User.count" do
      post users_url, params: { user: { email: "not-an-email", city_id: cities(:singapore).id } }
    end
  end

  test "should not create additional user if email has +" do
    email = users(:oscar).email
    email_components = email.split("@")
    email = email_components.first + "+1" + email_components.last

    assert_no_difference "User.count" do
      post users_url, params: { user: { email: email, city_id: cities(:singapore).id } }
    end
  end

  test "should not create user if terms of service and privacy policy are not accepted" do
    assert_no_difference "User.count" do
      post users_url, params: { user: { email: "test@example.com", city_id: cities(:singapore).id } }
    end
  end
end
