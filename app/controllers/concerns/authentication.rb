module Authentication
  extend ActiveSupport::Concern

  include Passwordless::ControllerHelpers

  included do
    before_action :set_current_user
    before_action :set_current_business, if: :signed_in?

    helper_method :signed_in?, :admin?
  end

  private

  def signed_in?
    Current.user.present?
  end

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) || authenticate_by_session(User)
  end

  def set_current_business
    Current.business = Current.user&.business
  end

  def require_user!
    return if signed_in?

    respond_to do |format|
      format.html do
        redirect_to(login_path)
      end

      format.turbo_stream do
        flash.now[:error] = "Please sign in to continue.".html_safe
        turbo_stream_flash(status: :unauthorized)
      end
    end
  end

  def require_business_owner!
    return if signed_in? && Current.user.business_owner?

    save_passwordless_redirect_location!(User)
    redirect_to(login_path)
  end

  def require_admin!
    head(:unauthorized) unless admin?
  end

  def require_unauth!
    redirect_to(root_path) if signed_in?
  end

  def admin?
    signed_in? && Current.user.admin?
  end
end
