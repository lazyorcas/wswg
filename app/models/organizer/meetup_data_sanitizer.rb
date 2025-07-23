class Organizer::MeetupDataSanitizer < Organizer::DataSanitizer
  def sanitize_url
    if normalized_url.include?("attendees")
      Url.build_url(normalized_url, "/#{group_slug}")
    else
      super
    end
  end

  def group_slug
    uri = Url.parse(normalized_url)
    uri.path.split("/").second
  end
end
