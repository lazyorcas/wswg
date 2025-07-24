class Businesses::OrganizersController < ApplicationController
  layout "businesses"

  include BusinessesOnly

  def index
  end
end
