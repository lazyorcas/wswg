class AdminConstraint
  include Passwordless::ControllerHelpers

  attr_accessor :session

  def matches?(request)
    self.session = request.session
    current_user.present? && current_user.admin?
  end

  def current_user
    User.find_by(id: session[:user_id]) || authenticate_by_session(User)
  end
end
