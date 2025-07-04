class BookmarksController < ApplicationController
  include CityDetection

  layout "home"

  def index
    ahoy.track "Visited bookmarks page"

    load_events
    if @events.any?
      load_city
      return respond_to_city_not_found if @city.nil?

      filter_out_past_events
      order_events
      @events = @events.includes(:source, :location, :city)
    end
  end

  def create
    ahoy.track "Bookmarked"

    build_bookmark
    return if @bookmark.persisted?

    begin
      @bookmark.save!
      flash.now[:success] = "Saved \"#{@bookmark.event.title}\""
    rescue => e
      Sentry.capture_exception(e)

      flash.now[:error] = "Failed to save \"#{@bookmark.event.title}\""
      turbo_stream_flash(status: :unprocessable_entity)
    end
  end

  def update
    load_bookmark
    build_bookmark

    begin
      @bookmark.save!
      if @bookmark.removed?
        ahoy.track "Removed bookmark"

        flash.now[:info] = "Unsaved \"#{@bookmark.event.title}\""
      else
        ahoy.track "Readded bookmark"

        flash.now[:success] = "Saved \"#{@bookmark.event.title}\""
      end
    rescue => e
      Sentry.capture_exception(e)

      flash.now[:error] = "Failed to save \"#{@bookmark.event.title}\""
      turbo_stream_flash(status: :unprocessable_entity)
    end
  end

  private

  def load_city
    @city = get_city_from_current_city || get_city_from_current_person
  end

  def load_events
    @events = event_scope.where(bookmarks: { removed: false })
  end

  def filter_out_past_events
    @events = @events.where(end_date: @city.time_zone.current_date..)
  end

    def order_events
      @events.order(:start_date, :start_time)
    end

  def event_scope
    Current.person.bookmarked_events
  end

  def load_bookmark
    @bookmark = bookmark_scope.find(params[:id])
  end

  def build_bookmark
    @bookmark ||= bookmark_scope.build
    @bookmark.attributes = bookmark_params
  end

  def bookmark_scope
    Current.person.bookmarks
  end

  def bookmark_params
    bookmark_params = params[:bookmark]
    bookmark_params ? bookmark_params.permit(:removed, :event_id) : {}
  end
end
