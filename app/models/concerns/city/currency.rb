module City::Currency
  extend ActiveSupport::Concern

  COUNTRY_CODE_TO_CURRENCY = {
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
    validates :currency,
      presence: true,
      inclusion: { in: Money::Currency.table.keys.map(&:to_s).map(&:upcase) }

    before_validation :set_currency
  end

  private

  def set_currency
    self.currency = COUNTRY_CODE_TO_CURRENCY[country_code] || FALLBACK_CURRENCY
  end
end
