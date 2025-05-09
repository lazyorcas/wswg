class UsersController < ApplicationController
  layout "home"

  before_action -> { redirect_to(map_path) }, if: :signed_in?

  def new; end
end
