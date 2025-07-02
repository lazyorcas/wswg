class CurrentVisitorController < ApplicationController
  include BotProtection

  protect_from_bots only: [ :edit ]
  before_action :require_unauth!

  def edit
    ahoy.track "Visited edit current visitor page"
  end

  def update
    Current.visitor.update!(visitor_params)
    redirect_to(referrer)
  end

  private

  def visitor_params
    visitor_params = params[:visitor]
    visitor_params ? visitor_params.permit(:city_id) : {}
  end

  def referrer
    if request.referer.include?(ENV["HOST_NAME"])
      request.referer
    else
      root_path
    end
  end
end
