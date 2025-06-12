require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  setup do
    @event = events(:first)
  end

  test "clicking on event title should create a seen" do
    visit root_path
    assert_difference "Seen.count", 1 do
      click_on @event.title
    end
  end

  test "click on more details should create a seen" do
    visit root_path
    assert_difference "Seen.count", 1 do
      find("summary", text: "More details").click
    end
  end
end
