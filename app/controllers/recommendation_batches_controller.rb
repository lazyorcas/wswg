class RecommendationBatchesController < ApplicationController
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper
  include Events

  def show
    load_city
    load_event_category
    load_time_period

    build_events
    filter_out_already_recommended_events
    limit_events_to_batch_size
    eager_load_events_associations

    build_recommendation_batch_path
  end

  private

  def recommendation_batch_render_mode
    params[:recommendation_batch_render_mode]
  end

  def already_recommended_event_ids
    (params[:already_recommended_event_ids] || []) + @events.pluck(:id)
  end

  def load_city
    @city = get_city_from_params ||
      get_city_from_current_city ||
      get_city_from_current_person
  end

  def filter_out_already_recommended_events
    @events = @events.where.not(id: already_recommended_event_ids)
  end

  def event_category_symbol
    EventCategory::SLUG_TO_SYMBOL_MAPPING[params[:event_category_slug]]
  end

  def time_period_symbol
    TimePeriod::SLUG_TO_SYMBOL_MAPPING[params[:time_period_slug]]
  end
end
