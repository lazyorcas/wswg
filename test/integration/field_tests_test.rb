require "test_helper"

class FieldTestsTest < ActionDispatch::IntegrationTest
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"

  test "should show pricing page" do
    get root_path, headers: { "User-Agent" => USER_AGENT }
    FieldTest::Membership.first.update(variant: "t")

    get root_path, headers: { "User-Agent" => USER_AGENT }
    assert_select "a[href=?]", pricing_path
  end

  test "should not show pricing page" do
    get root_path, headers: { "User-Agent" => USER_AGENT }
    FieldTest::Membership.first.update(variant: "f")

    get root_path, headers: { "User-Agent" => USER_AGENT }
    assert_select "a[href=?]", pricing_path, count: 0
  end
end
