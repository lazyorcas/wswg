class Event::NotFoundViaUrlError < StandardError
  attr_reader :url

  def initialize(url)
    super("Event not found via URL: #{url}")
    @url = url
  end
end
