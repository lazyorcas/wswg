class Source::Scraper::Strategy::BrowserBaseStrategy
  attr_reader :page_count

  def initialize(page_count: self.class.max_page_count)
    @page_count = page_count
  end

  def self.max_page_count
    raise NotImplementedError
  end

  def add_event_urls(page, &block)
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
