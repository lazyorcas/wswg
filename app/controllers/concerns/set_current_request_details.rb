module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action unless: -> { browser.bot? } do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip

      if request.location.present? && ahoy.visit.city.blank?
        begin
          city_name = request.location.city
          coordinates = Geocoder.search(city_name).first.coordinates

          ahoy.visit.update!(
            city: city_name,
            latitude: coordinates[0],
            longitude: coordinates[1],
            region: request.location.state_code.presence,
            country: request.location.country_code
          )
        rescue => e
          Sentry.capture_exception(e, extra: { location: request.location })
        end
      end
    end
  end
end
