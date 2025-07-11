class Marketing::PageBuilder::NearbyEventsPageBuilder < Marketing::EventsPageBuilder
  include Rails.application.routes.url_helpers
  include Marketing::Events::NearbyFilter
  include Marketing::Events::TimePeriodFilters
  include Marketing::Events::Ordering
  include Marketing::Events::Limiting

  def build_alternate_link_path(time_period_symbol)
    if time_period_symbol == :all
      all_nearby_events_path
    else
      time_period_slug = TimePeriod.slugify(time_period_symbol)
      nearby_events_path(time_period_slug: time_period_slug)
    end
  end

  def build_events_query
    filter_events_by_nearby
    filter_events_by_time_period
    order_events
    limit_events
  end

  private

  def city_i18n_key
    "nearby"
  end

  def i18n_params
    @i18n_params ||= { time_period: @time_period.name }
  end
end
