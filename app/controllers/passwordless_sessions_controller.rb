class PasswordlessSessionsController < Passwordless::SessionsController
  layout "home"

  before_action :require_unauth!, only: [ :new, :show ]
end
