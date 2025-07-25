class Organizer::MeetupDataSanitizer < Organizer::DataSanitizer
  def sanitize_url
    if should_sanitize_url?
      Url.build_url(normalized_url, "/#{group_slug}")
    else
      super
    end
  end

  def group_slug
    uri = Url.parse(normalized_event_url)
    uri.path.split("/").second
  end

  def should_sanitize_url?
    normalized_url.include?("attendees") || normalized_url.include?("members")
  end
end
