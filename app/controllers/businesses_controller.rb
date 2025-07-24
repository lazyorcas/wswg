class BusinessesController < ApplicationController
  include BusinessesOnly

  def show
    redirect_to business_events_path(business_id: Current.business.id)
  end
end
