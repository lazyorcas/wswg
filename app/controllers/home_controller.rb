class HomeController < ApplicationController
  def index
    redirect_to(map_path) if signed_in?
  end
end
