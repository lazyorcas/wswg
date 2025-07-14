class Source::Scraper::Strategy::Meetup < Source::Scraper::Strategy::BaseBrowserStrategy
  def self.max_page_count
    100
  end

  def get_event_attributes(page, &block)
    els = page.css("[data-element-name=\"categoryResults-eventCard\"] a")
    # old selector
    els = page.css("a#event-card-in-search-results") if els.empty?

    els.each do |el|
      url = el.attribute("href").split("?").first
      attrs = { url: url }
      yield attrs
    end
  end

  def go_to_next_page(page)
    page.scroll_to_load
  end
end
