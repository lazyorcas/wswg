class MapController < ApplicationController
  if Rails.env.production?
    rate_limit to: 10, within: 1.minute, only: :index
  end

  before_action :require_user!

  def index; end
end
