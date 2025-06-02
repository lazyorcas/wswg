class CurrentUserController < ApplicationController
  include StripeHelper

  before_action :require_user!

  def edit
  end

  def update
    Current.user.update!(user_params)
    redirect_to(map_path)
  end

  def top_up_credits
    ahoy.track "Visited top up page"

    redirect_to(build_stripe_payment_link(Current.user.email), allow_other_host: true)
  end

  def no_credits; end

  private

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(:city_id) : {}
  end
end
