class Marketing::PageBuilder::NearbyEventsPageBuilder < Marketing::EventsPageBuilder
  include Rails.application.routes.url_helpers
  include Marketing::Events::NearbyFilter
  include Marketing::Events::TimePeriodFilters
  include Marketing::Events::Ordering
  include Marketing::Events::Limiting

  attr_reader :time_period, :time_period_symbol, :city, :order_by

  def initialize(time_period:, city:, order_by: :time)
    @time_period = time_period
    @time_period_symbol = time_period.symbol
    @city = city
    @order_by = order_by
  end

  def build_meta_title
    begin
      t("meta_title.#{time_period.i18n_key}")
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
    if time_period_symbol == :all
      all_nearby_events_path
    else
      time_period_slug = TimePeriod.slugify(time_period_symbol)
      nearby_events_path(time_period_slug: time_period_slug)
    end
  end

  def build_alternate_link_title(time_period_symbol)
    time_period_name = TimePeriod.stringify(time_period_symbol)
    t("defaults.meta_title", time_period: time_period_name).professionalize
  end

  def build_events_query
    filter_events_by_nearby
    filter_events_by_time_period
    order_events
    limit_events
  end

  private

  def i18n_params
    @i18n_params ||= { time_period: time_period.name }
  end
end
