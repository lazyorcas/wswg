# TODO: add Timeout

SOURCE_URLS = [
  {
    name: "Eventbrite",
    homepage_url: "https://www.eventbrite.com",
    city_url_finder: Source::City::UrlFinder::Eventbrite,
    city_events_finder: CitySource::EventsFinder::Eventbrite,
    icon_url: "https://cdn.evbstatic.com/s3-build/prod/1918174-rc2025-04-02_20.04-py27-6dac8f6/django/images/favicons/favicon-96x96.png"
  },
  {
    name: "Luma",
    homepage_url: "https://lu.ma/discover",
    city_url_finder: Source::City::UrlFinder::Luma,
    city_events_finder: CitySource::EventsFinder::Luma,
    icon_url: "https://lu.ma/apple-touch-icon.png"
  },
  {
    name: "Meetup",
    homepage_url: "https://www.meetup.com",
    city_url_finder: Source::City::UrlFinder::Meetup,
    city_events_finder: CitySource::EventsFinder::Meetup,
    icon_url: "https://secure.meetupstatic.com/next/images/general/m_swarm_128x128.png"
  }
  # {
  #   name: "Klook",
  #   homepage_url: "https://www.klook.com",
  #   city_url_finder: Source::City::UrlFinder::Klook,
  #   city_events_finder: CitySource::EventsFinder::Klook,
  #   icon_url: "https://cdn.klook.com/s/dist_web/favicons/favicon-96x96.png"
  # },
]

SOURCE_URLS.each do |source_attributes|
  source = Source.find_or_initialize_by(homepage_url: source_attributes[:homepage_url])

  if source.new_record?
    source.assign_attributes(
      name: source_attributes[:name],
      city_url_finder_class_name: source_attributes[:city_url_finder].name,
      city_events_finder_class_name: source_attributes[:city_events_finder].name,
      icon_url: source_attributes[:icon_url]
    )
    source.save!
  end
end
