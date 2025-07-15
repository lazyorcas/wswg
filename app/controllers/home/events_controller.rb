class Home::EventsController < ApplicationController
  LIMIT = 10

  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper

  layout "home"

  after_action :add_event_to_seen_events, only: [ :show ], if: -> { Current.person.persisted? }

  helper_method :nearby?, :events?

  def index
    if nearby?
      @city = get_city_from_current_city
      if @city.nil?
        respond_to_city_not_found and return
      end
    else
      @city = get_city_from_params
      return head(:not_found) if @city.nil?
    end

    load_event_category
    load_time_period
    load_events_page_builder
    build_events
    @events = @events.includes(:source, :location, :city)

    if sort_by_interests?
      limit_events_to_batch_size
      load_next_event_batch_builder
      build_next_event_batch_path
    end

    build_meta_title
    build_meta_description
    build_title
    build_description
    build_alternate_link_attributes

    ahoy.track "Viewed events", city: @city.name, event_category: @event_category.name, time_period: @time_period.name, nearby: nearby?
  end

  def show
    load_event

    ahoy.track "Viewed event", event_id: @event.id, source: params[:source], sort_by: sort_by
  end

  private

  def events?
    @are_events ||= params[:event_category_slug] == "events"
  end

  def nearby?
    @is_nearby ||= params[:city_slug].blank?
  end

  def load_event_category
    event_category_symbol = EventCategory::SLUG_TO_SYMBOL_MAPPING[params[:event_category_slug]]
    @event_category = EventCategory.new(event_category_symbol)
  end

  def load_time_period
    time_period_symbol = TimePeriod::SLUG_TO_SYMBOL_MAPPING[params[:time_period_slug]]
    @time_period = TimePeriod.new(@city.time_zone, time_period_symbol)
  end

  def load_events_page_builder
    events_page_builder_params = {
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: sort_by
    }
    @events_page_builder = Marketing::EventsPageBuilderFactory.build(events_page_builder_params)
  end

  def build_events
    @events = @events_page_builder.build_events
  end

  def load_next_event_batch_builder
    @next_event_batch_builder = NextEventBatchBuilder.new(
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: sort_by
    )
  end

  def limit_events_to_batch_size
    @events = @events.limit(NextEventBatchBuilder::BATCH_SIZE)
  end

  def build_next_event_batch_path
    @next_event_batch_path = @next_event_batch_builder.build_path
  end

  def build_meta_title
    @meta_title = @events_page_builder.build_meta_title
  end

  def build_meta_description
    @meta_description = @events_page_builder.build_meta_description
  end

  def build_title
    @title = @events_page_builder.build_title
  end

  def build_description
    @description = @events_page_builder.build_description
  end

  def build_alternate_link_attributes
    @alternate_links_attributes = @events_page_builder.build_alternate_links_attributes
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
