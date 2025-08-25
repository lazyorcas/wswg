class ImpressionsController < ApplicationController
  def create
    ahoy.track "Impression", event_id: impression_params[:event_id]

    find_or_create_impression!
    head(:ok)
  end

  private

  def find_or_create_impression!
    impression_scope.find_or_create_by!(event_id: impression_params[:event_id])
  end

  def impression_scope
    Impression.where(impressionable: Current.person)
  end

  def impression_params
    impression_params = params[:impression]
    impression_params ? impression_params.permit(:event_id) : {}
  end
end
