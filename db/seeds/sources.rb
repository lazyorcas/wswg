# TODO: add Timeout

SOURCE_URLS = [
  {
    name: "Eventbrite",
    homepage_url: "https://www.eventbrite.com",
    city_url_finder: Source::City::UrlFinder::Eventbrite,
    city_events_finder: CitySource::EventsFinder::Eventbrite
  },
  {
    name: "Luma",
    homepage_url: "https://lu.ma/discover",
    city_url_finder: Source::City::UrlFinder::Luma,
    city_events_finder: CitySource::EventsFinder::Luma
  },
  {
    name: "Meetup",
    homepage_url: "https://www.meetup.com",
    city_url_finder: Source::City::UrlFinder::Meetup,
    city_events_finder: CitySource::EventsFinder::Meetup
  }
  # {
  #   name: "Klook",
  #   homepage_url: "https://www.klook.com",
  #   city_url_finder: Source::City::UrlFinder::Klook,
  #   city_events_finder: CitySource::EventsFinder::Klook,
  # },
]

SOURCE_URLS.each do |source_attributes|
  source = Source.find_or_initialize_by(homepage_url: source_attributes[:homepage_url])

  if source.new_record?
    source.assign_attributes(
      name: source_attributes[:name],
      city_url_finder_class_name: source_attributes[:city_url_finder].name,
      city_events_finder_class_name: source_attributes[:city_events_finder].name,
    )
    source.save!
  end
end
