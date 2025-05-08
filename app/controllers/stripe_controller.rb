class StripeController < ActionController::Base
  protect_from_forgery except: :webhook

  def webhook
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.configuration.stripe[:webhook_secret]
      )

    rescue JSON::ParserError
      head :bad_request
      return

    rescue Stripe::SignatureVerificationError
      head :bad_request
      return
    end

    case event.type
    when "payment_intent.succeeded"
      handle_payment_intent_succeeded(event.data.object)
    end

    head :ok
  end

  private

  def handle_payment_intent_succeeded(payment_intent)
    user = User.find_by(email: payment_intent.receipt_email)
    if user.nil?
      Sentry.capture_message("User not found for payment intent #{payment_intent.id}")
      return
    end

    checkout_session = retrieve_checkout_session(payment_intent.id)

    if checkout_session.nil?
      Sentry.capture_message("Checkout session not found for payment intent #{payment_intent.id}")
      return
    end

    amount = checkout_session.metadata["credits"].to_i
    user.add_credits!(amount, transaction_type: :paid_top_up)
  end

  def retrieve_checkout_session(payment_intent_id)
    Stripe::Checkout::Session.list(
      payment_intent: payment_intent_id,
      limit: 1
    ).data.first
  end
end
