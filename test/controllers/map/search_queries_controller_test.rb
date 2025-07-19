require "test_helper"

class Map::SearchQueriesControllerTest < ActionDispatch::IntegrationTest
  test "should create search query" do
    login_as(users(:oscar))

    post map_search_queries_url,
         params: { search_query: { query: "football" } },
         headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
  end
end
