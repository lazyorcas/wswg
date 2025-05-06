require "test_helper"

class StatisticsTest < ActiveSupport::TestCase
  test "should use min value for small set" do
    small_set = create_set((1..9).to_a)
    inliers = Statistics.calculate_inliers(small_set)

    assert_equal (Statistics::MIN_VALUE..9).to_a, get_values(inliers)
  end

  test "should use average for normal set" do
    normal_set = create_set((1..19).to_a)
    inliers = Statistics.calculate_inliers(normal_set)

    assert_equal (10..19).to_a, get_values(inliers)
  end

  test "should use boxplot for large set" do
    large_set_values =
      Array.new(10) { rand(1..5) } +
      Array.new(100) { rand(10..30) } +
      Array.new(990) { rand(100..200) }

    large_set = create_set(large_set_values.to_a)
    inliers = Statistics.calculate_inliers(large_set)

    assert_equal (100..200).to_a.sort, get_values(inliers).uniq.sort
  end

  private

  def create_set(values)
    values.map.with_index { |value, index| [ index, value ] }
  end

  def get_values(set)
    set.map { |p| p[1] }
  end
end
