class Source::Scraper::Strategy::BaseBrowserStrategy < Source::Scraper::Strategy::BaseStrategy
  def get_event_urls(page, &block)
    raise NotImplementedError
  end

  def go_to_next_page(page)
    raise NotImplementedError
  end
end
