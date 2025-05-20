module Authentication
  extend ActiveSupport::Concern

  include Passwordless::ControllerHelpers

  included do
    before_action :set_current_user
    before_action :associate_current_user_with_visit, if: :signed_in?

    helper_method :signed_in?
  end

  private

  def signed_in?
    Current.user.present?
  end

  def associate_current_user_with_visit
    ahoy.authenticate(Current.user)
  end

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) || authenticate_by_session(User)
  end

  def require_user!
    redirect_to(login_path) unless signed_in?
  end

  def require_admin!
    head(:unauthorized) unless Current.user&.admin?
  end

  def require_unauth!
    redirect_to(root_path) if signed_in?
  end
end
