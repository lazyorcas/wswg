class SearchesController < ApplicationController
  before_action :require_user!

  def index
    build_search
  end

  def create
    build_search
    @search.save!

    sleep(2)

    redirect_to(search_path(id: @search.public_id))
  rescue => e
    redirect_to(searches_path, error: e.message)
  end

  def show
    load_search

    if @search.completed?
      load_events

      if @events.empty?
        flash.now[:warning] = "Nothing found. Please try other search terms."
      end

    elsif @search.failed?
      flash.now[:error] = @search.result.error["message"]

    else
      flash.now[:info] = "Searching..."
    end
  end

  private

  def build_search
    @search ||= search_scope.build
    @search.attributes = search_params
  end

  def load_search
    @search = search_scope.find_by!(public_id: params[:id])
  end

  def load_events
    @events = Event
      .where(id: @search.result.ids)
      .order(start_date: :asc, start_time: :asc)
  end

  def search_scope
    Event::Search.where(user: current_user)
  end

  def search_params
    search_params = params[:event_search]
    search_params ? search_params.permit(:query) : {}
  end
end
