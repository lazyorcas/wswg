require "application_controller_test_case"

class HomeControllerTest < ApplicationControllerTestCase
  test "should get root" do
    get root_url
    assert_response :success
  end

  # test "should get pricing" do
  #   get pricing_url
  #   assert_response :success
  # end

  test "should get events directory" do
    get local_events_directory_url
    assert_response :success
  end

  test "every city_events url" do
    headers = build_human_headers
    events_directory_builder = Marketing::EventsDirectoryBuilder.new
    links_groups = events_directory_builder.build_links_attributes(complete: true)
    links_groups.each do |_, links|
      links.each do |link|
        get link[:href], headers: headers
        assert_response :success
      end
    end
  end

  test "visitor should generate a visit" do
    headers = build_human_headers

    assert_difference "Ahoy::Visit.count", 1 do
      get root_url, headers: headers
    end
  end

  test "bot should not generate a visit" do
    headers = build_bot_headers

    assert_difference "Ahoy::Visit.count", 0 do
      get root_url, headers: headers
    end
  end
end
