require "test_helper"

class TimePeriodTest < ActiveSupport::TestCase
  setup do
    @time_zone = TimeZone.new(name: "Asia/Singapore")
    @now = Time.parse("2025-05-22T12:00:00").in_time_zone(@time_zone.name)
  end

  test "today" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :today)
      assert_equal "2025-05-22", time_period.start_date.to_s
      assert_equal "2025-05-22", time_period.end_date.to_s
      assert_equal "12:00", time_period.start_time
      assert_equal "today", time_period.slug
    end
  end

  test "tonight" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :tonight)
      assert_equal "2025-05-22", time_period.start_date.to_s
      assert_equal "2025-05-22", time_period.end_date.to_s
      assert_equal "18:00", time_period.start_time
      assert_equal "tonight", time_period.slug
    end
  end

  test "tomorrow" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :tomorrow)
      assert_equal "2025-05-23", time_period.start_date.to_s
      assert_equal "2025-05-23", time_period.end_date.to_s
      assert_nil time_period.start_time
      assert_equal "tomorrow", time_period.slug
    end
  end

  test "this week" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :this_week)
      assert_equal "2025-05-22", time_period.start_date.to_s
      assert_equal "2025-05-25", time_period.end_date.to_s
      assert_nil time_period.start_time
      assert_equal "this-week", time_period.slug
    end
  end

  test "this weekend" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :this_weekend)
      assert_equal "2025-05-24", time_period.start_date.to_s
      assert_equal "2025-05-25", time_period.end_date.to_s
      assert_nil time_period.start_time
      assert_equal "this-weekend", time_period.slug
    end
  end

  test "next week" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :next_week)
      assert_equal "2025-05-26", time_period.start_date.to_s
      assert_equal "2025-06-01", time_period.end_date.to_s
      assert_nil time_period.start_time
      assert_equal "next-week", time_period.slug
    end
  end

  test "next weekend" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :next_weekend)
      assert_equal "2025-05-31", time_period.start_date.to_s
      assert_equal "2025-06-01", time_period.end_date.to_s
      assert_nil time_period.start_time
      assert_equal "next-weekend", time_period.slug
    end
  end

  test "all" do
    travel_to @now do
      time_period = TimePeriod.new(@time_zone, :all)
      assert_equal "2025-05-22", time_period.start_date.to_s
      assert_nil time_period.end_date
      assert_nil time_period.start_time
      assert_nil time_period.slug
    end
  end
end
