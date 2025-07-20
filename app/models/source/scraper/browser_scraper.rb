class Source::Scraper::BrowserScraper < Source::Scraper::BaseScraper
  INITIAL_PAGE_TIMEOUT = 20
  SUBSEQUENT_PAGE_TIMEOUT = 5

  def find_events_from_city_source(city_source)
    base_url = Url.get_base_url(city_source.url)
    events_attributes = []

    begin
      browser = load_browser
      page = go_to_url_from_browser(browser, city_source.url, city_source.city.country_code)

      max_page_count.times do |page_index|
        wait_for_idle(page, page_index)

        strategy.get_event_attributes(page) do |event_attributes|
          url = build_event_url(event_attributes[:url], base_url: base_url)
          event_attributes[:url] = url
          events_attributes << event_attributes
        end

        begin
          strategy.go_to_next_page(page)
        rescue Ferrum::NodeNotFoundError
          break
        end
      end
    rescue => e
      begin
        browser.quit
      rescue
      end
      if events_attributes.empty?
        raise Source::ScraperError.new(
          source_name: source.name,
          error_message: e.message
        )
      end
    ensure
      begin
        browser.quit
      rescue
      end
    end

    events_attributes.uniq { |event_attributes| event_attributes[:url] }
  end

  private

  def load_browser
    Possum::Browser.new
  end

  def go_to_url_from_browser(browser, url, country_code)
    page = browser.create_page(proxy: source.proxy?, country_code: country_code)
    page.go_to(url)
    page
  end

  def get_timeout(page_index)
    page_index == 0 ? INITIAL_PAGE_TIMEOUT : SUBSEQUENT_PAGE_TIMEOUT
  end

  def wait_for_idle(page, page_index)
    timeout = get_timeout(page_index)
    page.wait_for_idle(timeout: timeout)
  end

  def build_event_url(url, base_url:)
    path?(url) ? Url.build_url(base_url, url) : url
  end

  def path?(url)
    url.start_with?("/")
  end
end
