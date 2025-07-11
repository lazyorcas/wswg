class Marketing::PageBuilder::CityEventsPageBuilder < Marketing::EventsPageBuilder
  include Rails.application.routes.url_helpers
  include Marketing::Events::CityFilter
  include Marketing::Events::TimePeriodFilters
  include Marketing::Events::Ordering
  include Marketing::Events::Limiting

  def build_alternate_link_path(time_period_symbol)
    params = { city_slug: @city.slug }
    if time_period_symbol == :all
      all_city_events_path(**params)
    else
      time_period_slug = TimePeriod.slugify(time_period_symbol)
      city_events_path(time_period_slug: time_period_slug, **params)
    end
  end

  def build_events_query
    filter_events_by_city
    filter_events_by_time_period
    order_events
    limit_events
  end

  private

  def i18n_params
    @i18n_params ||= {
      city: @city.name,
      time_period: @time_period.name
    }
  end
end
