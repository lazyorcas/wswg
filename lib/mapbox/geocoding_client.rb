# https://docs.mapbox.com/api/search/geocoding/#geocoding-response-object

class Mapbox::GeocodingClient < GeocodingClient
  BASE_URL = "https://api.mapbox.com/search/geocode/v6"
  HEADERS = {
    "Content-Type": "application/json"
  }

  # https://docs.mapbox.com/api/search/geocoding/#forward-geocoding-with-search-text-input
  FORWARD_GEOCODING_URL = "#{BASE_URL}/forward"
  FORWARD_GEOCODING_PARAMS = {
    language: "en",
    autocomplete: false,
    types: [ "address" ]
  }
  def lookup(query)
    url = build_url(FORWARD_GEOCODING_URL, **FORWARD_GEOCODING_PARAMS, q: query)
    response = HTTParty.get(url)
    response_body = JSON.parse(response.body)
    get_lookup_entry(response_body)
  end

  private

  def build_url(path, **params)
    url = URI.parse(path)
    url.query = URI.encode_www_form(
      access_token: ENV["MAPBOX_ACCESS_TOKEN"],
      **params
    )
    url.to_s
  end

  def get_lookup_entry(entry)
    return nil if entry["features"].blank?

    properties = entry["features"].first["properties"]
    {
      full_address: properties["full_address"],
      lat: properties["coordinates"]["latitude"],
      lon: properties["coordinates"]["longitude"]
    }
  end
end
