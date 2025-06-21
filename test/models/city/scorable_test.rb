require "test_helper"

class City::ScorableTest < ActiveSupport::TestCase
  test "Singapore should have score = 0.01" do
    assert_equal 0.01, cities(:singapore).current_score
  end

  test "Munich should have score = 0" do
    assert_equal 0, cities(:munich).current_score
  end
end
