class Source::Scraper::Strategy::Eventbrite < Source::Scraper::Strategy::BaseBrowserStrategy
  def self.max_page_count
    50
  end

  def get_event_attributes(page, &block)
    page.css("a.event-card-link").each do |el|
      url = el.attribute("href")
      attrs = { url: url }
      yield attrs
    end
  end

  def go_to_next_page(page)
    page.click_on("button[aria-label=\"Next Page\"]")
  end
end
