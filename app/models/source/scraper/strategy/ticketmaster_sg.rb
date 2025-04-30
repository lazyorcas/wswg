class Source::Scraper::Strategy::TicketmasterSg < Source::Scraper::Strategy::BrowserBaseStrategy
  def self.max_page_count
    10
  end

  def add_event_urls(page, &block)
    page.css("a[href*=\"activity/detail\"]").each do |el|
      url = el.attribute("href")
      yield url
    end
  end

  def go_to_next_page(page)
    page.scroll_to_load
  end
end
