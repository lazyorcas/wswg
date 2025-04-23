class HomeController < ApplicationController
  if Rails.env.production?
    # Mapbox is free for 50,000 requests per month.
    # This rate limit is only for beta testing.
    rate_limit to: 10, within: 1.minute, only: :index, if: -> { Current.user.present? }
  end

  before_action :require_user!

  def index; end
end
