SOURCES_ATTRIBUTES = [
  [ "Eventbrite", "https://www.eventbrite.com/d/%{city_slug}/all-events/", "BrowserScraper", true ],
  [ "Luma", "https://lu.ma/%{city_slug}", "BrowserScraper", false ],
  [ "Meetup", "https://www.meetup.com/find/?location=%{city_slug}&eventType=inPerson&source=EVENTS&sortField=DATETIME", "BrowserScraper", false ],
  [ "Ticketmaster", "https://app.ticketmaster.com/discovery/v2/events.json", "ApiScraper", false ]
]

SOURCES_ATTRIBUTES.each do |attrs_array|
  name = attrs_array[0]
  source = Source.find_or_initialize_by(name: name)

  if source.new_record?
    source.attributes = {
      template_url: attrs_array[1],
      scraper_type: attrs_array[2],
      proxy: attrs_array[3]
    }
    source.save!
  end
end
