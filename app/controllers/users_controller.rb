class UsersController < ApplicationController
  layout "home"

  before_action -> { redirect_to(map_path) }, if: :signed_in?

  def new
    ahoy.track "Visited sign up page", params: params.slice(:city_id, :bookmark_event_id, :query)
  end
end
