class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Flash

  before_action :set_current_person
  before_action :set_sentry_user_context, if: :signed_in?

  private

  def set_current_person
    Current.person = Current.user || Current.visitor
  end

  def set_sentry_user_context
    Sentry.set_user({ id: Current.user.id })
  end
end
