require "test_helper"

class FieldTestsTest < ActionDispatch::IntegrationTest
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"

  test "should a/b test pricing page" do
    @path = root_path
    @experiment = "pricing_page_shown"

    init
    change_variant_to("t")
    assert_select "a[href=?]", pricing_path

    change_variant_to("f")
    assert_select "a[href=?]", pricing_path, count: 0
  end

  test "should a/b test sign up page" do
    @path = new_user_path
    @experiment = "sign_up_page"

    init
    change_variant_to("control")
    assert_select "#hero-image-container", count: 0
    assert_select "h1", text: "Create an account"

    change_variant_to("has_free_word")
    assert_select "#hero-image-container", count: 0
    assert_select "h1", text: "Create a free account"

    change_variant_to("has_hero_image")
    assert_select "#hero-image-container"
    assert_select "h1", text: "Create an account"

    change_variant_to("has_free_word_and_hero_image")
    assert_select "#hero-image-container"
    assert_select "h1", text: "Create a free account"
  end

  private

  def init
    visit
    @membership = FieldTest::Membership.find_by(experiment: @experiment)
  end

  def change_variant_to(variant)
    @membership.update(variant: variant)
    visit
  end

  def visit
    get @path, headers: { "User-Agent" => USER_AGENT }
  end
end
