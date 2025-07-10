class Marketing::PageBuilder::NearbySearchQueryEventsPageBuilder < Marketing::EventsPageBuilder
  include Rails.application.routes.url_helpers
  include Marketing::Events::NearbyFilter
  include Marketing::Events::SearchQueryFilter
  include Marketing::Events::TimePeriodFilters
  include Marketing::Events::Limiting

  attr_reader :event_category, :time_period, :time_period_symbol, :city

  def initialize(event_category:, time_period:, city:)
    @event_category = event_category
    @time_period = time_period
    @time_period_symbol = time_period.symbol
    @city = city
  end

  def build_meta_title
    t("defaults.meta_title", i18n_params).professionalize
  end

  def build_meta_description
    t("defaults.meta_description", i18n_params).professionalize
  end

  def build_title
    t("defaults.title", i18n_params).professionalize
  end

  def build_description
    build_meta_description
  end

  def build_alternate_link_path(time_period_symbol)
    params = { event_category_slug: event_category.slug }
    if time_period_symbol == :all
      all_nearby_search_query_events_path(**params)
    else
      time_period_slug = TimePeriod.slugify(time_period_symbol)
      nearby_search_query_events_path(time_period_slug: time_period_slug, **params)
    end
  end

  def build_alternate_link_title(time_period_symbol)
    time_period_name = TimePeriod.stringify(time_period_symbol)
    t("defaults.meta_title", **i18n_params, time_period: time_period_name).professionalize
  end

  def build_events_query
    filter_events_by_nearby
    filter_events_by_search_query
    filter_events_by_time_period
    order_events_by_search_query
    limit_events
  end

  private

  def i18n_params
    @i18n_params ||= { event_category: event_category.name, time_period: time_period.name }
  end
end
