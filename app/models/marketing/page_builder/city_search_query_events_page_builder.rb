class Marketing::PageBuilder::CitySearchQueryEventsPageBuilder < Marketing::EventsPageBuilder
  include Rails.application.routes.url_helpers
  include Marketing::Events::CityFilter
  include Marketing::Events::SearchQueryFilter
  include Marketing::Events::TimePeriodFilters
  include Marketing::Events::Limiting

  def build_alternate_link_path(time_period_symbol)
    params = { city_slug: @city.slug, event_category_slug: @event_category.slug }
    if time_period_symbol == :all
      all_city_search_query_events_path(**params)
    else
      time_period_slug = TimePeriod.slugify(time_period_symbol)
      city_search_query_events_path(time_period_slug: time_period_slug, **params)
    end
  end

  def build_events_query
    filter_events_by_city
    filter_events_by_search_query
    filter_events_by_time_period
    order_events_by_search_query
    limit_events
  end

  def build_map_path
    map_path(search_query_id: @search_query&.id)
  end

  private

  def i18n_params
    @i18n_params ||= {
      city: @city.name,
      event_category: @event_category.name,
      time_period: @time_period.name
    }
  end
end
