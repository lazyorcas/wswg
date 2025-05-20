class UsersController < ApplicationController
  layout "home"

  before_action :require_unauth!, only: :new

  def new
    build_user

    ahoy.track "Visited sign up page", params: {
      city_id: user_params[:city_id],
      bookmark_event_id: user_params.dig(:bookmarks_attributes, 0, :event_id),
      query: user_params.dig(:search_queries_attributes, 0, :query)
    }
  end

  def create
    build_user
    if @user.save
      redirect_to(login_path(email: @user.email))
    else
      Sentry.capture_exception(@user.errors.full_messages)
      render(new, status: :unprocessable_entity)
    end
  end

  private

  def build_user
    @user ||= User.build
    @user.attributes = user_params
  end

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(
      :email,
      :city_id,
      :terms_of_service_and_privacy_policy_accepted,
      bookmarks_attributes: [ :event_id ],
      search_queries_attributes: [ :query ]
    ) : {}
  end
end
