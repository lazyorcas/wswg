class Organizer::EventbriteDataSanitizer < Organizer::DataSanitizer
  GENERIC_URLS = [
    "https://www.eventbrite.com/",
    "https://www.eventbrite.sg/",
    "https://www.eventbrite.sg/organizer/overview/",
    "https://www.eventbrite.com/organizer/overview/"
  ].map { |url| Url.normalize(url) }.freeze

  def sanitize_url
    GENERIC_URLS.include?(normalized_url) ? nil : super
  end

  def sanitize_name
    @name == "Eventbrite" ? nil : super
  end
end
