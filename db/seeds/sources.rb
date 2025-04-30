class SourceAttributesBuilder
  def build_eventbrite_attributes(city_name, city_param)
    {
      city_name: city_name,
      source_name: "Eventbrite",
      url: "https://www.eventbrite.com/d/#{city_param}/all-events/",
      proxy: true
    }
  end

  def build_luma_attributes(city_name, city_param)
    {
      city_name: city_name,
      source_name: "Luma",
      url: "https://lu.ma/#{city_param}",
      proxy: false
    }
  end

  def build_meetup_attributes(city_name, city_param)
    {
      city_name: city_name,
      source_name: "Meetup",
      url: "https://www.meetup.com/find/?location=#{city_param}&eventType=inPerson&source=EVENTS&sortField=DATETIME",
      proxy: false
    }
  end
end

source_attributes_builder = SourceAttributesBuilder.new

SOURCES = [
  # Singapore
  source_attributes_builder.build_eventbrite_attributes("Singapore", "singapore"),
  source_attributes_builder.build_luma_attributes("Singapore", "singapore"),
  source_attributes_builder.build_meetup_attributes("Singapore", "sg--singapore"),

  # Barcelona
  source_attributes_builder.build_eventbrite_attributes("Barcelona", "spain--barcelona"),
  source_attributes_builder.build_luma_attributes("Barcelona", "barcelona"),
  source_attributes_builder.build_meetup_attributes("Barcelona", "es--barcelona"),

  # Munich
  source_attributes_builder.build_eventbrite_attributes("Munich", "germany--münchen"),
  source_attributes_builder.build_luma_attributes("Munich", "munich"),
  source_attributes_builder.build_meetup_attributes("Munich", "de--München"),

  # Berlin
  source_attributes_builder.build_eventbrite_attributes("Berlin", "germany--berlin"),
  source_attributes_builder.build_luma_attributes("Berlin", "berlin"),
  source_attributes_builder.build_meetup_attributes("Berlin", "de--Berlin"),

  # Paderborn
  source_attributes_builder.build_eventbrite_attributes("Paderborn", "germany--paderborn"),
  source_attributes_builder.build_meetup_attributes("Paderborn", "de--Paderborn")

  # Tokyo
  # source_attributes_builder.build_eventbrite_attributes("Tokyo", "japan--tokyo"),
  # source_attributes_builder.build_luma_attributes("Tokyo", "tokyo"),
  # source_attributes_builder.build_meetup_attributes("Tokyo", "jp--tokyo")
]

SOURCES.each do |source_attributes|
  city = City.find_by(name: source_attributes[:city_name])
  source = Source.find_by(name: source_attributes[:source_name])

  source = Source.find_or_initialize_by(
    city_id: city.id,
    name: source_attributes[:source_name]
  )

  if source.new_record?
    source.url = source_attributes[:url]
    source.proxy = source_attributes[:proxy]
    source.save!
  end
end

# Source.create(
#   city: City.find_by(name: "Munich"),
#   name: "MuenchenDe",
#   url: "https://www.muenchen.de/en/events",
#   proxy: false
# )
