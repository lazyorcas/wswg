class Source::Scraper::Strategy::BaseStrategy
  attr_reader :max_page_count

  def initialize(max_page_count: self.class.max_page_count)
    @max_page_count = max_page_count
  end

  def self.max_page_count
    raise NotImplementedError
  end
end
