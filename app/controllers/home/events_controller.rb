class Home::EventsController < ApplicationController
  include CityHelper

  EVENT_LIMIT_MAPPING = {
    today: 20,
    tonight: 10,
    tomorrow: 20,
    this_week: 50,
    this_weekend: 20,
    next_week: 50,
    next_weekend: 20,
    all: 100
  }

  layout "home"

  after_action :create_seen, only: [ :redirect ], unless: -> { browser.bot? }

  def index
    load_city
    if @city.nil?
      return head(:not_found)
    end

    load_current_time

    load_time_period
    load_events
    count_events
    order_events
    limit_events
    @events = @events.to_a
    build_alternate_link_attributes

    build_search_query

    ahoy.track "Viewed events", city: @city.name, time_period: @time_period.to_s

    if @events.empty? && @current_time.hour > 8
      Sentry.capture_message("No events", extra: { city: @city.name, time_period: @time_period.to_s, current_time: @current_time.strftime("%H:%M:%S") })
    end
  end

  def redirect
    load_event
    redirect_to(@event.url, allow_other_host: true)
  end

  private

  def load_city
    @city = City.find_by(slug: params[:city_slug])
  end

  def load_current_time
    @current_time = Time.current.in_time_zone(@city.time_zone.name)
  end

  def load_time_period
    time_period_symbol = TimePeriod::SLUG_TO_SYMBOL_MAPPING[params[:time_period_slug]] || :all
    @time_period = TimePeriod.new(@city.time_zone, time_period_symbol)
  end

  def load_events
    @events = Event
      .joins(:city_source)
      .left_joins(:seens)
      .where(city_source: { city_id: @city.id })
      .where(start_date: @time_period.start_date..@time_period.end_date)

    if @time_period.start_time.present?
      @events = @events.where("start_time >= ?", @time_period.start_time)
    end
  end

  def count_events
    @all_events_count = @events.count("DISTINCT events.id")
  end

  def order_events
    @events = @events
      .select("events.*, COUNT(seens.id) as seen_count")
      .group("events.id")
      .order("seen_count DESC, events.start_date, events.start_time")
  end

  def limit_events
    @events = @events.limit(EVENT_LIMIT_MAPPING[@time_period.to_sym])
  end

  def build_alternate_link_attributes
    alternate_time_periods_symbols = if @time_period.today?
      [ :tonight, :tomorrow, :this_week, :this_weekend ]
    elsif @time_period.tonight?
      [ :tomorrow, :this_week, :this_weekend ]
    elsif @time_period.tomorrow?
      [ :this_week, :this_weekend ]
    elsif @time_period.this_week?
      [ :this_weekend, :next_week ]
    elsif @time_period.this_weekend?
      [ :next_weekend, :next_week ]
    elsif @time_period.next_week?
      [ :next_weekend ]
    elsif @time_period.next_weekend?
      [ :all ]
    elsif @time_period.all?
      [ :today, :tonight, :tomorrow, :this_week, :this_weekend, :next_week, :next_weekend ]
    end

    @alternate_link_attributes = alternate_time_periods_symbols.map do |time_period_symbol|
      time_period = TimePeriod.new(@city.time_zone, time_period_symbol)

      {
        href: build_city_events_path(time_period_slug: time_period.slug),
        title: build_city_meta_title(@city, time_period_symbol)
      }
    end
  end

  def build_search_query
    @search_query = SearchQuery.new
  end

  def load_event
    @event = Event.find(params[:id])
  end

  def create_seen
    return if Current.person.seen_events.include?(@event)

    Current.person.seen_events << @event
    Current.person.save!
  rescue => e
    Sentry.capture_exception(e)
  end
end
