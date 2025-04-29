class Source::EventsFinder
  INITIAL_PAGE_TIMEOUT = 20
  SUBSEQUENT_PAGE_TIMEOUT = 5

  attr_reader :event_urls

  def initialize
    @source = nil
    @event_urls = []
  end

  def find_events(source_id)
    @source = Source.find(source_id)

    begin
      browser = Possum::Browser.new

      @page = browser.create_page(proxy: @source.proxy)
      @page.go_to(@source.url)

      max_page_count.times do |page|
        timeout = page == 0 ? INITIAL_PAGE_TIMEOUT : SUBSEQUENT_PAGE_TIMEOUT
        @page.wait_for_idle(timeout: timeout)

        get_events
        begin
          go_to_next_page

          break if done?
        rescue
          break
        end
      end
    rescue Ferrum::DeadBrowserError
      # ignore
    ensure
      begin
        browser.reset
        browser.quit
      rescue
        # ignore
      end
    end

    @event_urls = @event_urls.uniq
  end

  private

  def max_page_count
    raise NotImplementedError
  end

  def get_events
    raise NotImplementedError
  end

  def go_to_next_page
    raise NotImplementedError
  end

  def done?
    false
  end

  def host
    @host ||= URI.join(@source.url).host
  end

  def base_url
    @base_url ||= "https://#{host}"
  end
end
