# https://developers.cloudflare.com/fundamentals/reference/http-headers/#cf-connecting-ip

class Ahoy::Store < Ahoy::DatabaseStore
  include Passwordless::ControllerHelpers

  attr_accessor :session, :current_user

  EXCLUDED_PATHS = [
    "/jobs",
    "/field_test",
    "/up",
    "/manifest",
    "/service-worker",
    "/analytics"
  ].freeze

  def track_visit(data)
    set_session
    set_current_user

    lat = request.env["HTTP_CF_IPLATITUDE"]
    lon = request.env["HTTP_CF_IPLONGITUDE"]

    if current_user.present?
      data[:user_id] = current_user.id
      anonymized_data = Ahoy::Visit.anonymize(ip: request.remote_ip, lat: lat.to_f, lon: lon.to_f)

      data[:ip] = anonymized_data[:ip]
      data[:latitude] = anonymized_data[:lat]
      data[:longitude] = anonymized_data[:lon]
    else
      data[:ip] = request.env["HTTP_CF_CONNECTING_IP"] || request.remote_ip
      data[:latitude] = lat
      data[:longitude] = lon
    end

    data[:city] = request.env["HTTP_CF_IPCITY"]
    data[:region] = request.env["HTTP_CF_REGION"]
    data[:country] = request.env["HTTP_CF_IPCOUNTRY"]
    data[:time_zone] = request.env["HTTP_CF_TIMEZONE"]

    super(data)
  end

  def track_event(data)
    set_session
    set_current_user
    data[:user_id] = current_user&.id

    super(data)
  end

  private

  def set_session
    self.session = request.session
  end

  def set_current_user
    self.current_user = User.find_by(id: session[:user_id]) || authenticate_by_session(User)
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
