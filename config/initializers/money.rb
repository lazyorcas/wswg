Money.locale_backend = :currency

MoneyRails.configure do |config|
  config.default_currency = Money::Currency.new("SGD")
  config.rounding_mode = BigDecimal::ROUND_HALF_UP
  config.add_rate "SGD", "AUD", 1.20
  config.add_rate "SGD", "CAD", 1.06
  config.add_rate "SGD", "EUR", 0.69
  config.add_rate "SGD", "GBP", 0.58
  config.add_rate "SGD", "IDR", 12642.79
  config.add_rate "SGD", "JPY", 111.78
  config.add_rate "SGD", "KRW", 1060.35
  config.add_rate "SGD", "MYR", 3.3
  config.add_rate "SGD", "THB", 25.37
  config.add_rate "SGD", "USD", 0.78
  config.add_rate "SGD", "VND", 20225.10
end
