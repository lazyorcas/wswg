class Businesses::BookmarksController < ApplicationController
  layout "businesses"

  include BusinessesOnly

  def index
  end
end
