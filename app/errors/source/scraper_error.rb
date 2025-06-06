class Source::ScraperError < StandardError
  def initialize(source, error)
    @source = source
    @error = error
  end

  def message
    "Error scraping #{@source.name}: #{@error.message}"
  end
end
