module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
    before_action :associate_current_user_with_visit, if: :signed_in?

    helper_method :signed_in?
  end

  private

  def signed_in?
    Current.user.present? && Current.user.account.present?
  end

  def associate_current_user_with_visit
    ahoy.authenticate(Current.user)
  end

  def set_current_user
    return if session[:user_id].blank?

    Current.user = User.find_by(id: session[:user_id])
  end

  def require_user!
    redirect_to(login_path) unless signed_in?
  end

  def require_admin!
    head(:unauthorized) unless Current.user&.admin?
  end
end
