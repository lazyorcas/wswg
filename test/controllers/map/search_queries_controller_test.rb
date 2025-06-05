require "test_helper"

class Map::SearchQueriesControllerTest < ActionDispatch::IntegrationTest
  test "should create search query" do
    login_as(users(:oscar))

    post map_search_queries_url,
         params: { search_query: { query: "football" } },
         headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
  end

  test "should not create search query if user has no credits" do
    login_as(users(:finlay))

    post map_search_queries_url,
         params: { search_query: { query: "football" } },
         headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :payment_required
  end
end
