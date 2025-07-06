module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip

      if browser.bot? || ahoy.exclude?
        Current.visitor = Visitor.new(id: -1, visitor_token: ahoy.visitor_token)
      else
        Current.visitor = Visitor.find_or_create_by(visitor_token: ahoy.visitor_token)
      end

      city_name = request.env["HTTP_CF_IPCITY"]&.to_s&.encode("UTF-8", invalid: :replace, undef: :replace, replace: "")
      city = City.find_or_initialize_by(name: city_name)
      if city.persisted?
        Current.city = city
      else
        city.attributes = build_city_attributes_from_cloudflare_headers
        if city.valid?
          Current.city = city
        else
          Sentry.capture_message("Invalid city detected from Cloudflare headers.", level: :warning, extra: { city: city.attributes })
        end
      end
    end
  end

  private

  def build_city_attributes_from_cloudflare_headers
    {
      time_zone: build_time_zone_from_cloudflare_headers.name,
      country_code: request.env["HTTP_CF_IPCOUNTRY"],
      currency: City::Currency::COUNTRY_CODE_TO_CURRENCY[request.env["HTTP_CF_IPCOUNTRY"]] || City::Currency::FALLBACK_CURRENCY,
      lat: request.env["HTTP_CF_IPLATITUDE"],
      lon: request.env["HTTP_CF_IPLONGITUDE"]
    }
  end

  def build_time_zone_from_cloudflare_headers
    time_zone_name = request.env["HTTP_CF_TIMEZONE"]
    time_zone = TimeZone.new(name: time_zone_name)
    return time_zone if time_zone.valid?

    Sentry.capture_message("Invalid time zone detected from Cloudflare headers.", level: :warning, extra: { time_zone: time_zone_name })

    TimeZone.new(name: "Etc/UTC")
  end
end
