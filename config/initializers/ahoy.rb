class Ahoy::Store < Ahoy::DatabaseStore
  EXCLUDED_PATHS = [
    "/jobs",
    "/field_test",
    "/up",
    "/manifest",
    "/service-worker"
  ].freeze

  def track_visit(data)
    # https://developers.cloudflare.com/fundamentals/reference/http-headers/#cf-connecting-ip
    data[:ip] = request.env["HTTP_CF_CONNECTING_IP"] || request.remote_ip
    data[:latitude] = request.env["HTTP_CF_IPLATITUDE"]
    data[:longitude] = request.env["HTTP_CF_IPLONGITUDE"]
    data[:city] = request.env["HTTP_CF_IPCITY"]
    data[:region] = request.env["HTTP_CF_REGION"]
    data[:country] = request.env["HTTP_CF_IPCOUNTRY"]
    # time zone also available

    super(data)
  end
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false
# Ahoy.job_queue = :low_priority

Ahoy.exclude_method = lambda do |controller, request|
  Ahoy::Store::EXCLUDED_PATHS.any? { |path| request.path.start_with?(path) }
end
