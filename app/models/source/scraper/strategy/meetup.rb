class Source::Scraper::Strategy::Meetup < Source::Scraper::Strategy::BaseBrowserStrategy
  def self.max_page_count
    100
  end

  def get_event_urls(page, &block)
    els = page.css("[data-element-name=\"categoryResults-eventCard\"] a")
    # old selector
    els = page.css("a#event-card-in-search-results") if els.empty?

    els.each do |el|
      url = el.attribute("href").split("?").first
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
