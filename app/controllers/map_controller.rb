class MapController < ApplicationController
  include UserCreditsCheck

  rate_limit to: 10, within: 1.minute, only: :index

  before_action :require_user!

  def index; end
end
