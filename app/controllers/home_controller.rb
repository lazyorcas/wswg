class HomeController < ApplicationController
  layout "home"

  def index; end

  def pricing
    # ahoy.track("Visited Pricing Page")
  end
end
