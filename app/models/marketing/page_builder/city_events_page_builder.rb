class Marketing::PageBuilder::CityEventsPageBuilder < Marketing::EventsPageBuilder
  include Rails.application.routes.url_helpers
  include Marketing::Events::CityFilter
  include Marketing::Events::TimePeriodFilters
  include Marketing::Events::Ordering
  include Marketing::Events::Limiting

  attr_reader :time_period, :time_period_symbol, :city, :order_by

  def initialize(time_period:, city:, order_by: :time)
    @time_period = time_period
    @time_period_symbol = @time_period.symbol
    @city = city
    @order_by = order_by
  end

  def build_meta_title
    begin
      t("meta_title.#{city.i18n_key}.#{time_period.i18n_key}")
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
    params = { city_slug: city.slug }
    if time_period_symbol == :all
      all_city_events_path(**params)
    else
      time_period_slug = TimePeriod.slugify(time_period_symbol)
      city_events_path(time_period_slug: time_period_slug, **params)
    end
  end

  def build_alternate_link_title(time_period_symbol)
    time_period = TimePeriod.new(city.time_zone, time_period_symbol)
    begin
      t("meta_title.#{city.i18n_key}.#{time_period.i18n_key}")
    rescue
      t("defaults.meta_title", **i18n_params, time_period: time_period.name)
    end.professionalize
  end

  def build_events_query
    filter_events_by_city
    filter_events_by_time_period
    order_events
    limit_events
  end

  private

  def i18n_params
    @i18n_params ||= { city: city.name, time_period: time_period.name }
  end
end
