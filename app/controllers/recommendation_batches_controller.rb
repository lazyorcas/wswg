class RecommendationBatchesController < ApplicationController
  MAX_BATCH_COUNT = 100

  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper
  include Events

  helper_method :map?

  def show
    load_city
    load_event_category
    load_time_period

    if Current.person.seens.any?
      load_events
      filter_out_already_recommended_events
      limit_events_to_batch_size

      recommended_event_ids = @events.pluck(:id)

      if recommended_event_ids.length < MAX_BATCH_COUNT
        load_popular_events(limit: MAX_BATCH_COUNT - recommended_event_ids.length)
        filter_out_already_recommended_events
        event_ids = recommended_event_ids + @events.pluck(:id)
        @events = Event.where(id: event_ids).in_order_of(:id, event_ids)
      end
    else
      load_popular_events
      filter_out_already_recommended_events
      limit_events_to_batch_size
    end

    eager_load_events_associations

    if @events.any? && batch_index < MAX_BATCH_COUNT
      build_recommendation_batch_path(
        already_recommended_event_ids: already_recommended_event_ids + @events.pluck(:id),
        index: batch_index + 1
      )
    end
  end

  private

  def map?
    params[:map] == "true"
  end

  def already_recommended_event_ids
    (params[:already_recommended_event_ids] || [])
  end

  def batch_index
    params[:index].to_i
  end

  def load_city
    @city = get_city_from_params ||
      get_city_from_current_city ||
      get_city_from_current_person
  end

  def filter_out_already_recommended_events
    return if already_recommended_event_ids.empty?

    @events = @events.where.not(id: already_recommended_event_ids)
  end

  def load_popular_events(limit: MAX_BATCH_COUNT)
    @events = popular_events_page_builder.load_events
    @events = @events.limit(limit)
  end

  def event_category_symbol
    EventCategory::SLUG_TO_SYMBOL_MAPPING[params[:event_category_slug]]
  end

  def time_period_symbol
    TimePeriod::SLUG_TO_SYMBOL_MAPPING[params[:time_period_slug]]
  end

  def popular_events_page_builder
    @popular_events_page_builder ||= Marketing::EventsPageBuilderFactory.build({
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      sort_by: "popularity"
    })
  end
end
