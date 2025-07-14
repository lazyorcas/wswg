class Event::UrlNotFoundError < StandardError
  def initialize(url)
    super(url)
  end
end
