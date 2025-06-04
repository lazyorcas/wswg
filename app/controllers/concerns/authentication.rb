module Authentication
  extend ActiveSupport::Concern

  include Passwordless::ControllerHelpers

  included do
    before_action :set_current_user
    before_action :set_current_person
    before_action :associate_current_user_with_visit, if: :signed_in?
    before_action :set_sentry_user_context, if: :signed_in?

    helper_method :signed_in?
  end

  private

  def signed_in?
    Current.user.present?
  end

  def associate_current_user_with_visit
    ahoy.authenticate(Current.user)
  end

  def set_sentry_user_context
    Sentry.set_user({ id: Current.user.id })
  end

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) || authenticate_by_session(User)
  end

  def set_current_person
    Current.person = Current.user || Current.visitor
  end

  def require_user!
    return if signed_in?

    respond_to do |format|
      format.html do
        redirect_to(login_path, status: :temporary_redirect)
      end

      format.turbo_stream do
        flash.now[:error] = "Please <a href=\"#{login_path}\" class=\"link\">sign in</a> to continue.".html_safe
        turbo_stream_flash(status: :unauthorized)
      end
    end
  end

  def require_admin!
    head(:unauthorized) unless Current.user&.admin?
  end

  def require_unauth!
    redirect_to(root_path) if signed_in?
  end
end
