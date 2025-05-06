class MapController < ApplicationController
  include UserCreditsCheck

  if Rails.env.production?
    rate_limit to: 10, within: 1.minute, only: :index
  end

  before_action :require_user!
  require_credits

  def index; end
end
