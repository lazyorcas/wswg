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

      city = City.find_by_name(request.env["HTTP_CF_IPCITY"])
      if city.present?
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
  end

  private

  def build_city_attributes_from_cloudflare_headers
    {
      time_zone: request.env["HTTP_CF_TIMEZONE"],
      country_code: request.env["HTTP_CF_IPCOUNTRY"],
      currency: City::Currency::COUNTRY_CODE_TO_CURRENCY[request.env["HTTP_CF_IPCOUNTRY"]] || City::Currency::FALLBACK_CURRENCY,
      lat: request.env["HTTP_CF_IPLATITUDE"],
      lon: request.env["HTTP_CF_IPLONGITUDE"]
    }
  end
end
