class Organizer::EventbriteDataSanitizer < Organizer::DataSanitizer
  def sanitize_url
    root_url? || generic_url? ? nil : super
  end

  def sanitize_name
    @name == "Eventbrite" ? nil : super
  end

  def root_url?
    Url.parse(normalized_url).path.blank?
  end

  def generic_url?
    normalized_url.include?("organizer/overview")
  end
end
