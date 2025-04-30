module Source::EventsFindable
  INITIAL_PAGE_TIMEOUT = 20
  SUBSEQUENT_PAGE_TIMEOUT = 5

  def find_and_create_events!(city_source)
    event_urls = find_event_urls(city_source_url: city_source.url)
    create_jobs = build_create_event_jobs(city_source_id: city_source.id, event_urls: event_urls)

    if create_jobs.any?
      ActiveJob.perform_all_later(create_jobs)
    end
  end

  def find_event_urls(city_source_url:)
    event_urls = []

    begin
      browser = Possum::Browser.new

      page = browser.create_page(proxy: proxy)
      page.go_to(city_source_url)

      max_page_count = Rails.env.development? ? 2 : max_page_count

      max_page_count.times do |page_index|
        timeout = page_index == 0 ? INITIAL_PAGE_TIMEOUT : SUBSEQUENT_PAGE_TIMEOUT
        page.wait_for_idle(timeout: timeout)

        get_event_urls(page: page, city_source_url: city_source_url) do |event_url|
          event_urls << event_url
        end

        begin
          go_to_next_page(page: page)

          break if check_after_going_to_next_page? && done_after_going_to_next_page?(page: page)
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

  def build_create_event_jobs(city_source_id:, event_urls:)
    createable_urls = Event.get_createable_urls(event_urls)
    createable_urls.map do |event_url|
      Event::CreateJob.new(city_source_id: city_source_id, url: event_url)
    end
  end

  private

  def max_page_count
    raise NotImplementedError
  end

  def get_event_urls(page:, city_source_url:, &block)
    raise NotImplementedError
  end

  def go_to_next_page(page:)
    raise NotImplementedError
  end

  def check_after_going_to_next_page?
    false
  end

  def done_after_going_to_next_page?(page:)
    raise NotImplementedError
  end
end
