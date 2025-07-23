module Event::HandlesSources::Meetup
  extend ActiveSupport::Concern

  included do
    before_validation :modify_meetup_organizer_url, if: -> { from_meetup? && should_modify_meetup_organizer_url? }
  end

  def from_meetup?
    source.name == "Meetup"
  end

  def should_modify_meetup_organizer_url?
    organizer_url.include?("attendees")
  end

  def modify_meetup_organizer_url
    return unless should_modify_meetup_organizer_url?

    self.organizer_url = Url.build_url(url, "/#{meetup_group_slug}")
  end

  def meetup_group_slug
    uri = Url.parse(url)
    uri.path.split("/").second
  end
end
