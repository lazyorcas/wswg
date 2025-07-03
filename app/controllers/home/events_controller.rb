class Home::EventsController < ApplicationController
  include CityDetection
  include CityHelper
  include NearbyHelper
  include CurrentPerson::Settings::PreferencesHelper

  EVENT_LIMIT = 50

  layout "home"

  after_action :add_event_to_seen_events, only: [ :show ], if: -> { Current.person.persisted? }

  helper_method :nearby?, :all_events?

  def index
    if nearby?
      @city = get_city_from_visit
      build_city_from_visit

      if @city.name.blank? || @city.time_zone.blank?
        respond_to_city_not_found and return
      end

    else
      @city = get_city_from_params
      return head(:not_found) if @city.nil?
    end

    load_current_time

    load_event_category
    load_time_period
    load_events
    count_events
    order_events
    limit_events
    @events = @events.includes(:source, :location, :city)
    @events = @events.to_a

    build_meta_title
    build_title
    build_description
    build_alternate_link_attributes

    ahoy.track "Viewed events", city: @city.name, event_category: @event_category.to_s, time_period: @time_period.to_s, nearby: nearby?

    if browser.bot? && browser.bot.search_engine?
      Sentry.capture_message("[Search Engine] Viewed events", extra: {
        city: @city.name,
        time_period: @time_period.to_s,
        current_time: @current_time.strftime("%H:%M:%S"),
        nearby: nearby?,
        bot_name: browser.bot.name
      })
    end

    if @events.empty? && @current_time.hour > 8
      extra = {
        city: @city.name,
        time_period: @time_period.to_s,
        current_time: @current_time.strftime("%H:%M:%S"),
        event_category: @event_category.to_s
      }

      if browser.bot?
        Sentry.capture_message("No events for bot", extra: {
          **extra,
          bot_name: browser.bot.name
        })
      else
        Sentry.capture_message("No events for visitor", extra: extra)
      end
    end
  end

  def show
    load_event

    ahoy.track "Viewed event", event_id: @event.id, source: params[:source]
    sort_by_converted
  end

  private

  def all_events?
    @all_events ||= params[:event_category_slug] == "events"
  end

  def nearby?
    @is_nearby ||= params[:city_slug].blank?
  end

  def build_city_from_visit
    @city ||= City.new(
      name: request.env["HTTP_CF_IPCITY"],
      time_zone: request.env["HTTP_CF_TIMEZONE"]
    )
  end

  def load_current_time
    @current_time = Time.current.in_time_zone(@city.time_zone.name)
  end

  def load_event_category
    @event_category = EventCategory.new(params[:event_category_slug].to_sym)
  end

  def load_time_period
    time_period_symbol = TimePeriod::SLUG_TO_SYMBOL_MAPPING[params[:time_period_slug]] || :all
    @time_period = TimePeriod.new(@city.time_zone, time_period_symbol)
  end

  def load_events
    @events = if @event_category.events?
      Event
        .joins(:city)
        .where(city: { id: @city.id })
    else
      @search_query = SearchQuery
        .where(
          query: @event_category.query,
          city_id: @city.id,
          status: :completed,
          searcher: nil
        )
        .order(created_at: :desc)
        .last
      Event.where(id: @search_query&.result&.event_ids)
    end

    if @events.present?
      if @time_period.start_time.present?
        @events = @events.where("CONCAT(start_date, 'T', start_time) >= ?", "#{@time_period.start_date}T#{@time_period.start_time}")
      else
        @events = @events.where("start_date >= ?", @time_period.start_date)
      end

      if @time_period.end_date.present?
        @events = @events.where("end_date <= ?", @time_period.end_date)
      end
    end
  end

  def count_events
    @all_events_count = @events.count("DISTINCT events.id")
  end

  def order_events
    if @search_query.present?
      @events = @events.order(Arel.sql("array_position(ARRAY[#{@search_query.result.event_ids.join(',')}], events.id)"))
    else
      @events = if sort_by_time?
        @events.order(:start_date, :start_time)
      else
        @events
          .left_joins(:seens)
          .select("events.*, COUNT(DISTINCT seens.id) as seen_count")
          .group("events.id, sources.id, locations.id, city.id")
          .order("seen_count DESC, events.start_date, events.start_time")
      end
    end
  end

  def limit_events
    @events = @events.limit(EVENT_LIMIT)
  end

  def build_meta_title
    @meta_title = nearby? ?
      build_nearby_meta_title(@event_category.symbol, @time_period.to_sym) :
      build_city_meta_title(@city, @event_category.symbol, @time_period.to_sym)
  end

  def build_title
    @title = nearby? ?
      build_nearby_title(@event_category.symbol, @time_period.to_sym) :
      build_city_title(@city, @event_category.symbol, @time_period.to_sym)
  end

  def build_description
    @description = nearby? ?
      build_nearby_description(@event_category.symbol, @time_period) :
      build_city_description(@city, @event_category.symbol, @time_period)
  end

  def build_alternate_link_attributes
    alternate_time_periods_symbols = if @time_period.today?
      [ :tonight, :tomorrow, :this_week, :this_weekend, :all ]
    elsif @time_period.tonight?
      [ :tomorrow, :this_week, :this_weekend, :all ]
    elsif @time_period.tomorrow?
      [ :this_week, :this_weekend, :all ]
    elsif @time_period.this_week?
      [ :this_weekend, :next_week, :all ]
    elsif @time_period.this_weekend?
      [ :next_weekend, :next_week, :all ]
    elsif @time_period.next_week?
      [ :next_weekend, :all ]
    elsif @time_period.next_weekend?
      [ :all ]
    elsif @time_period.all?
      [ :today, :tonight, :tomorrow, :this_week, :this_weekend, :next_week, :next_weekend ]
    end

    @alternate_link_attributes = alternate_time_periods_symbols.map do |time_period_symbol|
      time_period = TimePeriod.new(@city.time_zone, time_period_symbol)

      {
        href: nearby? ?
          build_nearby_events_path(event_category_slug: @event_category.slug, time_period_slug: time_period.slug) :
          build_city_events_path(event_category_slug: @event_category.slug, city_slug: @city.slug, time_period_slug: time_period.slug),
        title: nearby? ?
          build_nearby_meta_title(@event_category.symbol, time_period_symbol) :
          build_city_meta_title(@city, @event_category.symbol, time_period_symbol)
      }
    end
  end

  def load_event
    @event = Event.find(params[:id])
  end

  def add_event_to_seen_events
    Person::AddEventToSeenEventsJob.perform_later(
      person_type: Current.person.class.name,
      person_id: Current.person.id,
      event_id: @event.id
    )
  end
end
