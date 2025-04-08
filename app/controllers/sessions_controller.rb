class SessionsController < ApplicationController
  def new; end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(email: auth_hash[:info][:email])

    account = Account.find_or_initialize_by(
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      user: user
    )

    account.auth_hash = auth_hash
    account.save!

    cookies.signed[:user_id] = user.id

    redirect_to(root_path)
  rescue => e
    redirect_to(login_path, error: e.message)
  end
end
