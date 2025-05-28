module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  COUNTRY_TO_CURRENCY = {
    "SG" => "SGD",
    "US" => "USD",
    "GB" => "GBP",
    # Europe
    "DE" => "EUR",
    "FR" => "EUR",
    "IT" => "EUR",
    "ES" => "EUR"
  }.freeze
  FALLBACK_CURRENCY = "USD".freeze

  included do
    before_action do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip

      if request.location.present?
        Current.country = request.location.country_code
        Current.city = request.location.city
        Current.coordinates = request.location.coordinates
      end

      Current.currency = COUNTRY_TO_CURRENCY[Current.country] || FALLBACK_CURRENCY
    end
  end
end
