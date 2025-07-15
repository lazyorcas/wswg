class Home::NextPersonalizedEventBatchesController < ApplicationController
  LIMIT = 10

  include CurrentPerson::Settings::PreferencesHelper

  def show
    load_city
    load_event_category
    load_time_period

    load_next_personalized_event_batch_builder
    @events = @next_personalized_event_batch_builder.build_events
    @events = @events.includes(:source, :location, :city)

    @next_personalized_event_batch_path = @next_personalized_event_batch_builder.build_path
  end

  private

  def load_city
    @city = City.find(params[:city_id])
  end

  def load_event_category
    event_category_symbol = EventCategory::SLUG_TO_SYMBOL_MAPPING[params[:event_category_slug]]
    @event_category = EventCategory.new(event_category_symbol)
  end

  def load_time_period
    time_period_symbol = TimePeriod::SLUG_TO_SYMBOL_MAPPING[params[:time_period_slug]]
    @time_period = TimePeriod.new(@city.time_zone, time_period_symbol)
  end

  def load_next_personalized_event_batch_builder
    @next_personalized_event_batch_builder = NextPersonalizedEventBatchBuilder.new(
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: sort_by
    )
  end
end
