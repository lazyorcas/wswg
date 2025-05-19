class Home::EventsController < ApplicationController
  EVENT_LIMIT = 50

  layout "home"

  after_action :create_seen, only: :redirect

  helper_method :today?, :tomorrow?, :this_week?, :next_week?

  def index
    load_city
    if @city.nil?
      head :not_found
      return
    end

    load_date_range
    load_events
    load_all_events_count

    build_time_period_text
    build_title
    build_description

    ahoy.track "Viewed events", city: @city.name, time_period: @time_period_text

    if @events.empty?
      Sentry.capture_message("No events found for #{@city.name} #{@time_period_text}")
    end
  end

  def redirect
    load_event
    redirect_to(@event.url, allow_other_host: true)
  end

  private

  def load_event
    @event = Event.find(params[:id])
  end

  def create_seen
    Seen.create!(event: @event, user: Current.user)
  end

  def build_title
    @title = "Events #{@time_period_text} in #{@city.name}"
  end

  def build_description
    date_range_text = if today? || tomorrow?
      @start_date.strftime("%B %d")

    elsif this_week? || next_week?
      "#{@start_date.beginning_of_week.strftime("%B %d")} - #{@end_date.end_of_week.strftime("%B %d")}"
    end

    @description = "What's happening in #{@city.name} #{@time_period_text} (#{date_range_text})? Discover local events from Luma, Meetup, Eventbrite, and Ticketmaster."
  end

  def load_city
    @city = City.find_by(slug: params[:city_slug])
  end

  def load_current_date
    @current_date = Time.current.in_time_zone(@city.time_zone.name).to_date
  end

  def load_date_range
    load_current_date

    if today?
      @start_date = @current_date
      @end_date = @current_date

    elsif tomorrow?
      tomorrow = @current_date + 1.day

      @start_date = tomorrow
      @end_date = tomorrow

    elsif this_week?
      @start_date = @current_date
      @end_date = @current_date.end_of_week

    elsif next_week?
      @start_date = @current_date.end_of_week.next_occurring(:monday)
      @end_date = @current_date.end_of_week.next_occurring(:sunday)

    end
  end

  def load_events
    @events = Event
      .joins(:city_source)
      .where(city_sources: { city: @city })
      .where(end_date: @start_date..@end_date)
      .order(:start_date, :start_time)
      .limit(EVENT_LIMIT)
      .includes(:city)
  end

  def load_all_events_count
    @all_events_count = Event
      .joins(:city_source)
      .where(city_sources: { city: @city })
      .where(end_date: @start_date..@end_date)
      .count
  end

  def build_time_period_text
    @time_period_text = if today?
      "today"
    elsif tomorrow?
      "tomorrow"
    elsif this_week?
      "this week"
    elsif next_week?
      "next week"
    end
  end

  def today?
    request.path.include?("today")
  end

  def tomorrow?
    request.path.include?("tomorrow")
  end

  def this_week?
    request.path.include?("this-week")
  end

  def next_week?
    request.path.include?("next-week")
  end
end
