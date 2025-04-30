class Source::Scraper::Strategy::BaseStrategy
  attr_reader :page_count

  def initialize(page_count_modifier: 1)
    @page_count = self.class.max_page_count * page_count_modifier
  end

  def self.max_page_count
    raise NotImplementedError
  end
end
