# https://github.com/mikker/passwordless/blob/ac74e1c8c46b714c457214dbdd4f172d57a30ea5/app/controllers/passwordless/sessions_controller.rb#L251

class SessionsController < ApplicationController
  layout "home"

  before_action :require_unauth!, only: :new

  def new
    @passwordless_session = Passwordless::Session.new

    ahoy.track "Visited login page"
  end
end
