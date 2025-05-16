class UsersController < ApplicationController
  layout "home"

  before_action -> { redirect_to(map_path) }, if: :signed_in?

  def new
    ahoy.track("Visited sign up page")
  end
end
