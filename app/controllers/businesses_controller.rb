class BusinessesController < ApplicationController
  include BusinessesOnly

  def show
    redirect_to business_events_path
  end
end
