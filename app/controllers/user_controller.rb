class UserController < ApplicationController
  include StripeHelper

  before_action :require_user!

  def top_up_credits
    ahoy.track "Visited top up page"

    redirect_to(build_stripe_payment_link(Current.user.email), allow_other_host: true)
  end

  def no_credits; end
end
