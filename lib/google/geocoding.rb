class Google::Geocoding
  BASE_URL = "https://maps.googleapis.com/maps/api/geocode/json"

  # https://developers.google.com/maps/documentation/geocoding/requests-geocoding
  def self.lookup(address)
    url = build_url(address)
    response = HTTParty.get(url)
    response_body = JSON.parse(response.body)

    return nil if response_body["status"] != "OK"

    data = response_body["results"].first
    {
      full_address: data["formatted_address"],
      latitude: data["geometry"]["location"]["lat"],
      longitude: data["geometry"]["location"]["lng"]
    }
  end

  private

  def self.build_url(address)
    url = URI.parse(BASE_URL)
    url.query = URI.encode_www_form(
      key: ENV["GOOGLE_API_KEY"],
      language: "en",
      address: address
    )
    url.to_s
  end
end
