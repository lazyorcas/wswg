require "test_helper"

class User::CreditsTest < ActiveSupport::TestCase
  test "should have credits" do
    assert users(:oscar).has_credits?
  end

  test "should have credits because of ongoing usage transaction" do
    assert users(:lily).has_credits?
  end

  test "should top up paid credits" do
    original_credits = users(:oscar).credits

    users(:oscar).add_paid_credits!(10)
    users(:oscar).reload

    assert_equal original_credits + 10, users(:oscar).credits
  end

  test "should top up free credits" do
    original_credits = users(:oscar).credits

    users(:oscar).add_free_credits!
    users(:oscar).reload

    assert_equal original_credits + 2, users(:oscar).credits
  end

  test "should not top up free credits twice for the same month" do
    original_credits = users(:oscar).credits

    users(:oscar).add_free_credits!
    users(:oscar).add_free_credits!
    users(:oscar).reload

    assert_equal original_credits + 2, users(:oscar).credits
  end

  test "should deduct credits on usage" do
    original_credits = users(:oscar).credits

    users(:oscar).use_credit!
    users(:oscar).reload

    assert_equal original_credits - 1, users(:oscar).credits
  end

  test "should not deduct credits twice" do
    users(:oscar).use_credit!
    users(:oscar).reload
    credits = users(:oscar).credits

    users(:oscar).use_credit!
    users(:oscar).reload

    assert_equal credits, users(:oscar).credits
  end

  test "should deduct credits on usage after the last usage transaction expires" do
    original_credits = users(:oscar).credits

    travel_to(credit_transactions(:usage).expires_at) do
      users(:oscar).use_credit!
      users(:oscar).reload

      assert_equal original_credits - 1, users(:oscar).credits
    end
  end

  test "should not create credit transaction if user has ongoing usage transaction" do
    3.times { users(:oscar).use_credit! }
    users(:oscar).reload

    assert_equal 1, users(:oscar).credit_transactions.ongoing.usage.count
  end
end
