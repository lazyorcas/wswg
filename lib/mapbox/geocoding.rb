# https://docs.mapbox.com/api/search/geocoding/#geocoding-response-object

class Mapbox::Geocoding
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
  def self.lookup(query)
    url = build_url(FORWARD_GEOCODING_URL, **FORWARD_GEOCODING_PARAMS, q: query)
    response = HTTParty.get(url)
    response_body = JSON.parse(response.body)
    get_lookup_entry(response_body)
  end

  # https://docs.mapbox.com/api/search/geocoding/#batch-geocoding
  BATCH_GEOCODING_URL = "#{BASE_URL}/batch"
  MAX_BATCH_SIZE = 1000
  def self.batch_lookup(queries)
    lookup = {}
    url = build_url(BATCH_GEOCODING_URL)
    unique_queries = queries.uniq

    unique_queries.each_slice(MAX_BATCH_SIZE) do |queries|
      body = queries.map do |query|
        {
          **FORWARD_GEOCODING_PARAMS,
          q: query
        }
      end

      response = HTTParty.post(url, headers: HEADERS, body: body.to_json)
      response_body = JSON.parse(response.body)

      queries.each_with_index do |query, index|
        entry = response_body["batch"][index]
        lookup[query] = get_lookup_entry(entry)
      end
    end

    lookup
  end

  private

  def self.build_url(path, **params)
    url = URI.parse(path)
    url.query = URI.encode_www_form(
      access_token: ENV["MAPBOX_ACCESS_TOKEN"],
      **params
    )
    url.to_s
  end

  def self.get_lookup_entry(entry)
    return nil if entry["features"].blank?

    properties = entry["features"].first["properties"]
    {
      full_address: properties["full_address"],
      lat: properties["coordinates"]["latitude"],
      lon: properties["coordinates"]["longitude"]
    }
  end
end
