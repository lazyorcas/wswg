class Source::ScraperError < StandardError
  def initialize(source_name:, error_message:)
    @source_name = source_name
    @error_message = error_message
  end

  def message
    "Error scraping #{@source_name}: #{@error_message}"
  end
end
