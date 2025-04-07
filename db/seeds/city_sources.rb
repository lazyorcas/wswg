SINGAPORE_SOURCES = [
  {
    source_name: "Eventbrite",
    url: "https://www.eventbrite.com/d/singapore/all-events/"
  },
  {
    source_name: "Luma",
    url: "https://lu.ma/singapore"
  },
  {
    source_name: "Meetup",
    url: "https://www.meetup.com/find/?location=sg--singapore&eventType=inPerson&source=EVENTS&sortField=DATETIME"
  }
]

SINGAPORE_SOURCES.each do |source_attributes|
  city = City.find_by(name: "Singapore")
  source = Source.find_by(name: source_attributes[:source_name])

  city_source = CitySource.find_or_initialize_by(
    city_id: city.id,
    source_id: source.id
  )

  if city_source.new_record?
    city_source.assign_attributes(
      url: source_attributes[:url],
      verified: true
    )
    city_source.save!
  end
end
