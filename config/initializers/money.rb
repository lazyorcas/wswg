MoneyRails.configure do |config|
  config.default_currency = Money::Currency.new("SGD")
  config.rounding_mode = BigDecimal::ROUND_HALF_UP
  config.add_rate "SGD", "USD", 0.78
  config.add_rate "SGD", "GBP", 0.58
  config.add_rate "SGD", "EUR", 0.69
end
