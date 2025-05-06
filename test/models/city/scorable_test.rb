require "test_helper"

class City::ScorableTest < ActiveSupport::TestCase
  test "London should have score = 0" do
    assert_equal 0, cities(:london).current_score
  end

  test "Singapore should have score = 0.1" do
    assert_equal 0.1, cities(:singapore).current_score
  end

  test "Munich should have score = 1" do
    assert_equal 1, cities(:munich).current_score
  end
end
