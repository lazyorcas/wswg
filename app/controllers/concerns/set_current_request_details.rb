module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action unless: -> { browser.bot? } do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip

      if request.location.present?
        begin
          city_name = request.location.city
          coordinates = Geocoder.search(city_name).first.coordinates
          Current.city = City.find_or_create_by!(
            name: city_name,
            lat: coordinates[0],
            lon: coordinates[1],
            country_code: request.location.country_code,
            time_zone: request.location.time_zone
          )
        rescue => e
          Sentry.capture_exception(e, extra: { location: request.location })
        end
      end
    end
  end
end
