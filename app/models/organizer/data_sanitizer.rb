class Organizer::DataSanitizer
  attr_reader :sanitized_attributes

  def initialize(url:, name:, event_url:)
    @url = url
    @name = name
    @sanitized_attributes = {}
  end

  def sanitize
    @sanitized_attributes[:url] = @url.present? ? sanitize_url : nil
    @sanitized_attributes[:name] = @name.present? ? sanitize_name : nil
  end

  def sanitize_url
    normalized_url
  end

  def sanitize_name
    @name
  end

  private

  def normalized_url
    @normalized_url ||= Url.normalize(@url)
  end

  def normalized_event_url
    @normalized_event_url ||= Url.normalize(@event_url)
  end
end
