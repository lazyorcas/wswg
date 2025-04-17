class SearchesController < ApplicationController
  before_action :require_user!

  def index
    build_search
  end

  def create
    build_search
    @search.save!
  rescue => e
    flash.now[:error] = e.message
    turbo_stream_flash
  end

  private

  def build_search
    @search ||= search_scope.build
    @search.attributes = search_params
  end

  def search_scope
    Event::Search.where(user: Current.user)
  end

  def search_params
    search_params = params[:event_search]
    search_params ? search_params.permit(:query) : {}
  end
end
