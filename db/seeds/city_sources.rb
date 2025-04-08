class CitySourceAttributesBuilder
  def self.build_eventbrite_attributes(city_name, city_param)
    {
      city_name: city_name,
      source_name: "Eventbrite",
      url: "https://www.eventbrite.com/d/#{city_param}/all-events/"
    }
  end

  def self.build_luma_attributes(city_name, city_param)
    {
      city_name: city_name,
      source_name: "Luma",
      url: "https://lu.ma/#{city_param}"
    }
  end

  def self.build_meetup_attributes(city_name, city_param)
    {
      city_name: city_name,
      source_name: "Meetup",
      url: "https://www.meetup.com/find/?location=#{city_param}&eventType=inPerson&source=EVENTS&sortField=DATETIME"
    }
  end
end

CITY_SOURCES = [
  # Singapore
  CitySourceAttributesBuilder.build_eventbrite_attributes("Singapore", "singapore"),
  CitySourceAttributesBuilder.build_luma_attributes("Singapore", "singapore"),
  CitySourceAttributesBuilder.build_meetup_attributes("Singapore", "sg--singapore"),

  # Barcelona
  CitySourceAttributesBuilder.build_eventbrite_attributes("Barcelona", "spain--barcelona"),
  CitySourceAttributesBuilder.build_luma_attributes("Barcelona", "barcelona"),
  CitySourceAttributesBuilder.build_meetup_attributes("Barcelona", "es--barcelona"),

  # Munich
  CitySourceAttributesBuilder.build_eventbrite_attributes("Munich", "germany--münchen"),
  CitySourceAttributesBuilder.build_luma_attributes("Munich", "munich"),
  CitySourceAttributesBuilder.build_meetup_attributes("Munich", "de--München"),

  # Berlin
  CitySourceAttributesBuilder.build_eventbrite_attributes("Berlin", "germany--berlin"),
  CitySourceAttributesBuilder.build_luma_attributes("Berlin", "berlin"),
  CitySourceAttributesBuilder.build_meetup_attributes("Berlin", "de--Berlin"),

  # Tokyo
  CitySourceAttributesBuilder.build_eventbrite_attributes("Tokyo", "japan--tokyo"),
  CitySourceAttributesBuilder.build_luma_attributes("Tokyo", "tokyo"),
  CitySourceAttributesBuilder.build_meetup_attributes("Tokyo", "jp--tokyo")
]

CITY_SOURCES.each do |city_source_attributes|
  city = City.find_by(name: city_source_attributes[:city_name])
  source = Source.find_by(name: city_source_attributes[:source_name])

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
