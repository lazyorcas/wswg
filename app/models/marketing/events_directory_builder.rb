class Marketing::EventsDirectoryBuilder
  include Rails.application.routes.url_helpers

  def build_links_attributes(complete: false)
    links_groups = []

    load_cities
    load_time_periods
    load_event_categories(complete: complete)

    if complete
      title = "Events near me"
      links = @event_categories.map do |event_category|
        @time_periods.map do |time_period|
          if event_category.events?
            {
              href: time_period.all? ?
                all_nearby_events_path :
                nearby_events_path(time_period_slug: time_period.slug),
              title: I18n.t("marketing.nearby_events_page_builder.defaults.meta_title", time_period: time_period.name).professionalize
            }
          else
            {
              href: time_period.all? ?
                all_nearby_search_query_events_path(event_category_slug: event_category.slug) :
                nearby_search_query_events_path(event_category_slug: event_category.slug, time_period_slug: time_period.slug),
              title: I18n.t("marketing.nearby_search_query_events_page_builder.defaults.meta_title", event_category: event_category.name, time_period: time_period.name).professionalize
            }
          end
        end
      end.flatten

      links << {
        href: map_path,
        title: "Events map",
        turbo: false
      }

      links_groups << [ title, links ]
    end

    links_groups += @cities.map do |city|
      title = "Events in #{city.name}"

      links = @event_categories.map do |event_category|
        @time_periods.map do |time_period|
          if event_category.events?
            params = { city_slug: city.slug }
            i18n_params = { city: city.name, time_period: time_period.name }
            {
              href: time_period.all? ?
                all_city_events_path(params) :
                city_events_path(**params, time_period_slug: time_period.slug),
              title: I18n.t("marketing.city_events_page_builder.defaults.meta_title", **i18n_params).professionalize
            }
          else
            params = { city_slug: city.slug, event_category_slug: event_category.slug }
            i18n_params = { city: city.name, event_category: event_category.name, time_period: time_period.name }
            {
              href: time_period.all? ?
                all_city_search_query_events_path(params) :
                city_search_query_events_path(**params, time_period_slug: time_period.slug),
              title: I18n.t("marketing.city_search_query_events_page_builder.defaults.meta_title", **i18n_params).professionalize
            }
          end
        end
      end.flatten

      links << {
        href: city_map_path(city_slug: city.slug),
        title: "#{city.name} events map",
        turbo: false
      }

      [ title, links ]
    end
  end

  private

  def load_cities
    @cities = City.enabled.order(:name)
  end

  def load_time_periods
    @time_periods = TimePeriod::SYMBOLS.map do |time_period_symbol|
      TimePeriod.new("UTC", time_period_symbol)
    end
  end

  def load_event_categories(complete: false)
    event_category_symbols = complete ? EventCategory::SYMBOLS : [ :events ]
    @event_categories = event_category_symbols.map do |event_category_symbol|
      EventCategory.new(event_category_symbol)
    end
  end
end
