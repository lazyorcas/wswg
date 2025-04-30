class Source::Scraper::BrowserScraper < Source::Scraper::BaseScraper
  DEV_MAX_PAGE_COUNT = 2

  INITIAL_PAGE_TIMEOUT = 20
  SUBSEQUENT_PAGE_TIMEOUT = 5

  def find_event_urls_from_url(url)
    base_url = Url.get_base_url(url)
    event_urls = []

    begin
      browser = load_browser
      page = go_to_url_from_browser(browser, url)

      page_count.times do |page_index|
        wait_for_idle(page, page_index)
        strategy.add_event_urls(page) do |url|
          event_url = build_event_url(url, base_url: base_url)
          event_urls |= [ event_url ]
        end
        begin
          strategy.go_to_next_page(page)
          break if
            strategy.check_after_going_to_next_page? &&
            strategy.done_after_going_to_next_page?(page)
        rescue
          break
        end
      end
    rescue Ferrum::DeadBrowserError
    ensure
      begin
        browser.reset
        browser.quit
      rescue
      end
    end

    event_urls.uniq
  end

  private

  def load_browser
    Possum::Browser.new
  end

  def go_to_url_from_browser(browser, url)
    page = browser.create_page(proxy: source.proxy?)
    page.go_to(url)
  end

  def page_count
    Rails.env.development? ? DEV_MAX_PAGE_COUNT : strategy.page_count
  end

  def get_timeout(page_index)
    page_index == 0 ? INITIAL_PAGE_TIMEOUT : SUBSEQUENT_PAGE_TIMEOUT
  end

  def wait_for_idle(page, page_index)
    timeout = get_timeout(page_index)
    page.wait_for_idle(timeout: timeout)
  end

  def build_event_url(url, base_url)
    path?(url) ? Url.build_url(base_url, url) : url
  end

  def path?(url)
    url.start_with?("/")
  end
end
