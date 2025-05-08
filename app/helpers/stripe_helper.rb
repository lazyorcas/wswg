module StripeHelper
  def build_stripe_payment_link(email)
    "#{ENV["STRIPE_PAYMENT_LINK"]}?prefilled_email=#{email}"
  end
end
