class SessionsController < ApplicationController
  layout "home"

  before_action -> { redirect_to(map_path) }, if: :signed_in?, only: [ :new ]

  def new; end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_or_initialize_by(email: auth_hash[:info][:email])

    if user.new_record?
      origin = request.env["omniauth.origin"]

      city_id = Url.extract_query_param(origin, "city_id")&.to_i
      if city_id.nil?
        raise UserReadableError.new("You didn't select a city.")
      end
      user.city_id = city_id
      user.save!

      bookmark_event_id = Url.extract_query_param(origin, "bookmark_event_id")&.to_i
      if bookmark_event_id.present?
        begin
          Bookmark.create!(user: user, event_id: bookmark_event_id)
        rescue => e
          Sentry.capture_exception(e)
        end
      end

      query = Url.extract_query_param(origin, "query")
      if query.present?
        begin
          @search_query = user.search_queries.create!(query: query)
        rescue => e
          Sentry.capture_exception(e)
        end
      end
    end

    create_or_update_account!(user, auth_hash)
    session[:user_id] = user.id

    if @search_query.present?
      redirect_to(map_path(search_query_id: @search_query.id))
    else
      redirect_to(map_path)
    end

  rescue => e
    Sentry.capture_exception(e)

    if e.is_a?(UserReadableError)
      flash.now[:error] = e.message
    else
      flash.now[:error] = "Failed to login. Try again."
    end

    turbo_stream_flash
  end

  def create_or_update_account!(user, auth_hash)
    account = Account.find_or_initialize_by(
      provider: auth_hash[:provider],
      uid: auth_hash[:uid]
    )
    account.user_id = user.id
    account.auth_hash = auth_hash
    account.save!
  end
end
