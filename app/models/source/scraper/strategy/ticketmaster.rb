class Source::Scraper::Strategy::Ticketmaster < Source::Scraper::Strategy::BaseApiStrategy
  def self.max_page_count
    10
  end

  def fetch_city_source(city_source, page_index:)
    Ticketmaster.event_search(
      lat: city_source.city.lat,
      lon: city_source.city.lon,
      radius: Event::Locatable::MAX_DISTANCE_TO_CITY,
      unit: Event::Locatable::DISTANCE_UNIT,
      page: page_index
    )
  end

  def get_events_attributes(response, &block)
    response.dig("_embedded", "events")&.each do |data|
      start_date = data.dig("dates", "start", "localDate")
      end_date = data.dig("dates", "end", "localDate")

      venue = data.dig("_embedded", "venues", 0)
      address = venue["address"]["line1"]
      postal_code = venue["postalCode"]
      city = venue["city"]["name"]
      country = venue["country"]["name"]

      classifications = data["classifications"]

      event_attributes = {
        url: data["url"].split("?").first,
        title: data["name"],
        tags: classifications ? classifications.map { |c| c["segment"]["name"] }.uniq.join(" ") : nil,
        image_url: data.dig("images", 0, "href"),
        start_date: start_date,
        end_date: end_date || start_date,
        start_time: data.dig("dates", "start", "localTime"),
        end_time: data.dig("dates", "end", "localTime"),
        location_query: "#{address}, #{postal_code} #{city}, #{country}"
      }

      yield event_attributes
    end
  end

  def has_more_pages?(response)
    response.dig("_links", "next").present?
  end
end
