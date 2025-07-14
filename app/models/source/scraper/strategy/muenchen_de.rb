class Source::Scraper::Strategy::MuenchenDe < Source::Scraper::Strategy::BaseBrowserStrategy
  def self.max_page_count
    100
  end

  def get_event_attributes(page, &block)
    page.css(".m-event-list-item a").each do |el|
      url = el.attribute("href").split("?").first
      attrs = { url: url }
      yield attrs
    end
  end

  def go_to_next_page(page)
    page.click_on(".m-pagination__item.m-pagination__item--next-page a")
  end
end
