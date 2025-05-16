class UsersController < ApplicationController
  layout "home"

  before_action -> { redirect_to(map_path) }, if: :signed_in?

  def new
    ahoy.track("Visited Sign Up Page")
  end
end
