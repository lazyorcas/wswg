class CurrentUserController < ApplicationController
  include StripeHelper

  before_action :require_user!

  helper_method :referrer

  def edit
    ahoy.track "Visited edit current user page"
  end

  def update
    Current.user.update!(user_params)
    redirect_to(params[:return_to] || root_path)
  end

  private

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(:city_id) : {}
  end

  def referrer
    request.referer if request.referer&.include?(ENV["HOST_NAME"])
  end
end
