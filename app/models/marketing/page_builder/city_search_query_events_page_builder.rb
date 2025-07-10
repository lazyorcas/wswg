class Marketing::PageBuilder::CitySearchQueryEventsPageBuilder < Marketing::EventsPageBuilder
  include Rails.application.routes.url_helpers
  include Marketing::Events::CityFilter
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
    begin
      t("meta_title.#{city.i18n_key}.#{event_category.i18n_key}.#{time_period.i18n_key}")
    rescue
      t("defaults.meta_title", i18n_params)
    end.professionalize
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
    params = { city_slug: city.slug, event_category_slug: event_category.slug }
    if time_period_symbol == :all
      all_city_search_query_events_path(**params)
    else
      time_period_slug = TimePeriod.slugify(time_period_symbol)
      city_search_query_events_path(time_period_slug: time_period_slug, **params)
    end
  end

  def build_alternate_link_title(time_period_symbol)
    time_period = TimePeriod.new(city.time_zone, time_period_symbol)
    begin
      t("meta_title.#{city.i18n_key}.#{event_category.i18n_key}.#{time_period.i18n_key}")
    rescue
      t("defaults.meta_title", **i18n_params, time_period: time_period.name)
    end.professionalize
  end

  def build_events_query
    filter_events_by_city
    filter_events_by_search_query
    filter_events_by_time_period
    order_events_by_search_query
    limit_events
  end

  private

  def i18n_params
    @i18n_params ||= { event_category: event_category.name, time_period: time_period.name, city: city.name }
  end
end
