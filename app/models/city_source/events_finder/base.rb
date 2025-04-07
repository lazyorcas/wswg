class CitySource::EventsFinder::Base
  include Fetch::WithBrowser

  MAX_PAGE_COUNT = 10
  SLEEP_BETWEEN_PAGES = 2

  attr_reader :events

  def initialize(
    max_page_count: MAX_PAGE_COUNT,
    sleep_between_pages: SLEEP_BETWEEN_PAGES
  )
    @city_source = nil
    @max_page_count = max_page_count
    @sleep_between_pages = sleep_between_pages
    @events = []
  end

  def find_events(city_source_id)
    @city_source = CitySource.find(city_source_id)

    begin
      load_browser
      @browser.go_to(@city_source.url)

      @max_page_count.times do |page|
        find_events_in_browser
        begin
          go_to_next_page
        rescue
          break
        end
        sleep(@sleep_between_pages)
      end

      @events = @events.uniq { |event| event[:uid] }
    ensure
      @browser.reset
    end
  end

  private

  def find_events_in_browser
    raise NotImplementedError
  end

  def go_to_next_page
    raise NotImplementedError
  end

  def end_of_page?
    current_scroll = @browser.evaluate("window.pageYOffset + window.innerHeight")
    total_height = @browser.evaluate("document.documentElement.scrollHeight")
    current_scroll >= total_height
  end
end
