class OmniauthSessionsController < ApplicationController
  def create
    load_auth_hash
    find_or_create_user!
    create_or_update_account!
    store_session
    load_recent_search_query
    if @recent_search_query.present?
      redirect_to(map_path(search_query_id: @recent_search_query.id))
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
    turbo_stream_flash(status: :unprocessable_entity)
  end

  private

  def load_auth_hash
    @auth_hash = request.env["omniauth.auth"]
  end

  def find_or_create_user!
    @user = User.find_or_create_by!(email: @auth_hash.dig(:info, :email))
  end

  def create_or_update_account!
    account = Account.find_or_initialize_by(
      provider: @auth_hash[:provider],
      uid: @auth_hash[:uid]
    )
    account.user_id = @user.id
    account.auth_hash = @auth_hash
    account.save!
  end

  def store_session
    session[:user_id] = @user.id
  end

  def load_recent_search_query
    @search_query = @user.search_queries
      .where(created_at: 5.minutes.ago..)
      .order(created_at: :desc)
      .first
  end
end
