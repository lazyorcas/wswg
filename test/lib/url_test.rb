require "test_helper"

class UrlTest < ActiveSupport::TestCase
  test "get_base_url" do
    assert_equal "https://example.com", Url.get_base_url("https://example.com/")
    assert_equal "https://example.com", Url.get_base_url("http://example.com/foo/bar")
    assert_equal "https://example.com", Url.get_base_url("https://example.com/?city=münchen")
    assert_equal "https://münchen.de", Url.get_base_url("https://münchen.de/")
  end

  test "build_url" do
    assert_equal "https://example.com/foo/bar", Url.build_url("https://example.com", "/foo/bar")
    assert_equal "https://example.com/baz", Url.build_url("https://example.com/", "baz")
  end

  test "build_utm_url" do
    url = "https://example.com/search"
    assert_equal "https://example.com/search?utm_campaign=campaign&utm_source=source&utm_medium=medium", Url.build_utm_url(url, campaign: "campaign", source: "source", medium: "medium")

    url_with_query = "https://example.com/search?old=param"
    assert_equal "https://example.com/search?old=param&utm_campaign=campaign&utm_source=source&utm_medium=medium", Url.build_utm_url(url_with_query, campaign: "campaign", source: "source", medium: "medium")
  end

  test "build_parameterized_url" do
    url = "https://example.com/search"
    params = { q: "ruby", page: 2 }
    assert_equal "https://example.com/search?q=ruby&page=2", Url.build_parameterized_url(url, params)

    url_with_query = "https://example.com/search?old=param"
    params = { new: "value" }
    assert_equal "https://example.com/search?new=value", Url.build_parameterized_url(url_with_query, params)
  end

  test "extract_query_param" do
    url = "https://example.com/?mode=search"
    assert_equal "search", Url.extract_query_param(url, "mode")

    path = "/?mode=search"
    assert_equal "search", Url.extract_query_param(path, "mode")
  end
end
