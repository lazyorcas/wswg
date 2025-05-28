require "test_helper"

class CurrencyTest < ActiveSupport::TestCase
  test "exchange rates are available" do
    assert_nothing_raised do
      currencies = %w[SGD USD GBP EUR]
      currencies.each do |currency|
        Money.from_amount(1).exchange_to(currency)
      end
    end
  end
end
