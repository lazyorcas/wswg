require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "should be completed" do
    assert_predicate events(:first), :data_completed?
  end

  test "should be incomplete" do
    event = Event.new(url: "https://example.com/events/incomplete")
    assert_not event.data_completed?
  end

  test "should be duplicated" do
    event = events(:first).dup
    assert_predicate event, :duplicated?
  end

  test "should be duplicated when title only changes slightly" do
    event = events(:first).dup
    event.city_source = city_sources(:meetup)
    event.title = event.title + " (changed location)"
    assert_predicate event, :duplicated?
  end

  test "should not be duplicated when title changes significantly" do
    event = events(:first).dup
    event.title = "Football"
    assert_not event.duplicated?
  end

  test "should not be createable" do
    url = events(:first).url
    createable_url = Event.extract_createable_urls_from_urls([ url ])
    assert_empty createable_url
  end

  test "should build url for Luma" do
    event = Event.find_or_initialize_by(url: "https://lu.ma/example")
    event.city_source = city_sources(:luma)
    event.attributes = {
      title: "Hello world",
      image_url: "https://example.com/image.jpg",
      start_date: Time.current.to_date.to_s,
      end_date: Time.current.to_date.to_s,
      start_time: "18:00"
    }
    event.save!
    event.reload

    assert_match(/date=/, event.url)
  end
end
