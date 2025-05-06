class Source::Scraper::Strategy::BaseBrowserStrategy < Source::Scraper::Strategy::BaseStrategy
  def get_event_urls(page, &block)
    raise NotImplementedError
  end

  def go_to_next_page(page)
    raise NotImplementedError
  end

  def check_after_going_to_next_page?
    false
  end

  def done_after_going_to_next_page?(page)
    raise NotImplementedError
  end
end
