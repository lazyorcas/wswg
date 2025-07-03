class CurrentVisitorController < ApplicationController
  before_action :require_unauth!

  helper_method :referrer

  def edit
    ahoy.track "Visited edit current visitor page"
  end

  def update
    Current.visitor.update!(visitor_params)
    redirect_to(params[:return_to] || root_path)
  end

  private

  def visitor_params
    visitor_params = params[:visitor]
    visitor_params ? visitor_params.permit(:city_id) : {}
  end

  def referrer
    request.referer if request.referer&.include?(ENV["HOST_NAME"])
  end
end
