class UsersController < ApplicationController
  layout "home"

  before_action :require_unauth!, only: :new

  def new
    build_user

    ahoy.track "Visited sign up page", params: {
      city_id: user_params[:city_id],
      bookmark_event_id: user_params.dig(:bookmarks_attributes, "0", :event_id),
      query: user_params.dig(:search_queries_attributes, "0", :query),
      referrer: request.referer,
      source: params[:source]
    }
  end

  def create
    build_user
    @user.save!
    redirect_to(
      login_path(email: @user.email),
      flash: { success: "Account created successfully. You can now login to your account." }
    )

  rescue => e
    Sentry.capture_exception(e)
    error_message = if User.find_by(email: @user.email).present?
      "Email already exists."
    else
      "Failed to create account. Please try again."
    end
    redirect_to(new_user_path, flash: { error: error_message })
  ensure
    field_test_converted(:sign_up_page)
  end

  private

  def build_user
    @user ||= User.build
    @user.attributes = user_params
    @user.city_id ||= City.find_by(name: request.location.city)&.id
  end

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(
      :email,
      :city_id,
      :notification_frequency,
      bookmarks_attributes: [ :event_id ],
      search_queries_attributes: [ :query ]
    ) : {}
  end
end
