module CitySource::EventsFindable
  def find_and_create_events!
    city_events_finder_class = (
      city_events_finder_class_name ||
      source.city_events_finder_class_name
    ).constantize

    city_events_finder = city_events_finder_class.constantize.new
    events_attributes = city_events_finder.find_events(id)

    events_attributes.each do |event_attributes|
      Event::CreateJob.perform_later(
        city_id: city_id,
        city_source_id: id,
        uid: event_attributes[:uid],
        url: event_attributes[:url]
      )
    end
  end
end
