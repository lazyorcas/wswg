class SessionsController < ApplicationController
  def new
    redirect_to(root_path) if signed_in?
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(email: auth_hash[:info][:email])
    if user.nil?
      redirect_to(login_path, flash: { error: "User not found. Please contact me for access." })
      return
    end

    account = find_or_create_account(auth_hash, user)

    session[:user_id] = account.user.id

    redirect_to(root_path)
  rescue => e
    Sentry.capture_exception(e)

    if e.is_a?(UserReadableError)
      flash.now[:error] = e.message
    else
      flash.now[:error] = "Failed to login. Try again."
    end

    turbo_stream_flash
  end

  private

  def find_or_create_account(auth_hash, user)
    account = Account.find_or_initialize_by(
      provider: auth_hash[:provider],
      uid: auth_hash[:uid]
    )

    account.user = user
    account.auth_hash = auth_hash
    account.save!

    account
  end
end
