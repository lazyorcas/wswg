class SessionsController < ApplicationController
  rate_limit to: 5, within: 1.day, only: :create

  def new; end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_or_create_by!(email: auth_hash[:info][:email])

    account = Account.find_or_initialize_by(
      provider: auth_hash[:provider],
      uid: auth_hash[:uid]
    )

    account.user = user
    account.auth_hash = auth_hash
    account.save!

    session[:user_id] = account.user.id

    redirect_to(root_path)
  rescue => e
    Sentry.capture_exception(e)

    if e.is_a?(UserReadableError)
      flash.now[:error] = e.message
    else
      flash.now[:error] = "Failed to sign in. Try again."
    end

    turbo_stream_flash
  end
end
