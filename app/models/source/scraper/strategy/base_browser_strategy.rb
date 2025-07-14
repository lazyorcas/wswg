class Source::Scraper::Strategy::BaseBrowserStrategy < Source::Scraper::Strategy::BaseStrategy
  def get_event_attributes(page, &block)
    raise NotImplementedError
  end

  def go_to_next_page(page)
    raise NotImplementedError
  end
end
