class Source::Scraper::Strategy::TicketmasterSg < Source::Scraper::Strategy::BaseBrowserStrategy
  def self.max_page_count
    10
  end

  def get_event_urls(page, &block)
    page.css("a[href*=\"activity/detail\"]").each do |el|
      url = el.attribute("href")
      yield url
    end
  end

  def go_to_next_page(page)
    page.scroll_to_load
  end
end
