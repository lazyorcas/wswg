class SessionsController < ApplicationController
  rate_limit to: 5, within: 1.day, only: :create

  def new; end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(email: auth_hash[:info][:email])

    if user.nil?
      raise UserReadableError.new("Account not found")
    end

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
    flash.now[:error] = e.message
    turbo_stream_flash
  end
end
