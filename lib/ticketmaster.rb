# frozen_string_literal: true

class Ticketmaster
  BASE_URL = "https://app.ticketmaster.com"
  TIMEOUT = 20

  EVENT_SEARCH_PATH = "/discovery/v2/events.json"
  EVENT_SEARCH_PARAMS = {
    locale: "en",
    size: 200,
    includeTBA: "no",
    includeTBD: "no"
  }

  def self.event_search(latitude:, longitude:, radius:, unit:, page: 0)
    url = build_url(EVENT_SEARCH_PATH, {
      **EVENT_SEARCH_PARAMS,
      geoPoint: "#{latitude},#{longitude}",
      radius: radius,
      unit: unit,
      page: page
    })

    response = HTTParty.get(url, timeout: TIMEOUT)
    response.parsed_response
  end

  private

  def self.build_url(path, params)
    Url.get_parameterized_url("#{BASE_URL}#{path}", {
      **params,
      apikey: ENV["TICKETMASTER_API_KEY"]
    })
  end
end
