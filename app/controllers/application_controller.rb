class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :warning

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: cookies.signed[:user_id])
  end

  def require_user!
    redirect_to(login_path) unless current_user.present?
  end
end
