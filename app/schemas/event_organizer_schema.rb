class EventOrganizerSchema < RubyLLM::Schema
  any_of :organizer_url, description: "URL of the organizer, usually a user/member page of the hosting platform. The organizer can also be referred to as the event's host. Look out for \"Hosted by\" or \"Organized by\" in the content, but don't rely on it. Use null if unknown" do
    string
    null
  end
  any_of :organizer_name, description: "Name of the organizer. The organizer can also be referred to as the event's host. Look out for \"Hosted by\" or \"Organized by\" in the content, but don't rely on it. It cannot be the name of the hosting platform. Use null if unknown" do
    string
    null
  end
end
