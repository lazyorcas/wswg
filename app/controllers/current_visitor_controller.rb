class CurrentVisitorController < ApplicationController
  def edit
  end

  def update
    Current.visitor.update!(visitor_params)
    redirect_to(map_path)
  end

  private

  def visitor_params
    visitor_params = params[:visitor]
    visitor_params ? visitor_params.permit(:city_id) : {}
  end
end
