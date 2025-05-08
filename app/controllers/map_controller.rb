class MapController < ApplicationController
  rate_limit to: 10,
    within: 1.minute,
    only: :index,
    with: -> { redirect_to(root_path, flash: { error: "Too many requests. Please try again in 1 minute." }) }

  before_action :require_user!

  def index; end
end
