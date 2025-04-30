class Source::Scraper::Strategy::Luma < Source::Scraper::Strategy::BrowserBase
  def self.max_page_count
    10
  end

  def add_event_urls(page, &block)
    page.css("a.event-link").each do |el|
      url = el.attribute("href")
      yield url
    end
  end

  def go_to_next_page(page)
    page.scroll_to_load
  end

  def check_after_going_to_next_page?
    true
  end

  def done_after_going_to_next_page?(page)
    page.end_of_page?
  end
end
