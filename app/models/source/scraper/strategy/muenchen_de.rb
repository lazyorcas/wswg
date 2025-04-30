class Source::Scraper::Strategy::MuenchenDe < Source::Scraper::Strategy::BrowserBase
  def self.max_page_count
    100
  end

  def add_event_urls(page, &block)
    page.css(".m-event-list-item a").each do |el|
      url = el.attribute("href").split("?").first
      yield url
    end
  end

  def go_to_next_page(page)
    page.click_on(".m-pagination__item.m-pagination__item--next-page a")
  end
end
