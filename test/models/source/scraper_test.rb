require "test_helper"

class Source::ScraperTest < ActiveSupport::TestCase
  # test "should scrape Eventbrite" do
  #   events_attributes = scrape(city_sources(:eventbrite))
  #   assert_events_attributes(events_attributes)
  # end

  # test "should scrape Luma" do
  #   events_attributes = scrape(city_sources(:luma))
  #   assert_events_attributes(events_attributes)
  # end

  # test "should scrape Meetup" do
  #   events_attributes = scrape(city_sources(:meetup))
  #   assert_events_attributes(events_attributes)
  # end

  # test "should scrape Ticketmaster" do
  #   events_attributes = scrape(city_sources(:ticketmaster))
  #   assert_events_attributes(events_attributes)
  # end

  private

  def scrape(city_source)
    city_source.source.scrape(city_source)
  end

  def assert_events_attributes(events_attributes)
    assert_not_empty events_attributes
    assert_not_nil events_attributes.first[:url]
  end
end
