class EventSchema < RubyLLM::Schema
  string :title
  string :description, description: "Full description in markdown format"
  string :image_url
  any_of :organizer_url, description: "URL of the organizer, usually a user/member page of the hosting platform. The organizer can also be referred to as the event's host. Look out for \"Hosted by\" or \"Organized by\" in the content, but don't rely on it. Use null if unknown" do
    string
    null
  end
  any_of :organizer_name, description: "Name of the organizer. The organizer can also be referred to as the event's host. Look out for \"Hosted by\" or \"Organized by\" in the content, but don't rely on it. It cannot be the name of the hosting platform. Use null if unknown" do
    string
    null
  end
  any_of :location, description: "Location of the event. It can be a precise address or a general area. If the location is online / virtual, return an empty string. If the location is to be determined / TBD, return an empty string. Use null if unknown" do
    string
    null
  end
  any_of :start_date, description: "Use null if unknown" do
    string format: "date"
    null
  end
  any_of :start_time, description: "Start time of the event in HH:mm:ss format. Use null if unknown" do
    string
    null
  end
  any_of :end_date, description: "Use null if unknown" do
    string format: "date"
    null
  end
  any_of :end_time, description: "End time of the event in HH:mm:ss format. Use null if unknown" do
    string
    null
  end
  any_of :price, description: "Price of the event. If there's a range, return the minimum price. Round up to the nearest integer. If the price is free, return 0. Use null if unknown" do
    number
    null
  end
  any_of :attendees_count, description: "Number of attendees. Use null if unknown" do
    number
    null
  end
  boolean :not_found, description: "If the event is not found, return true. Otherwise, return false."
end
