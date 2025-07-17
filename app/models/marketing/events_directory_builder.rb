class Marketing::EventsDirectoryBuilder
  include Rails.application.routes.url_helpers

  def build_links_attributes(complete: false)
    links_groups = []

    load_cities
    load_time_periods
    load_event_categories(complete: complete)

    if complete
      nearby_city = City.first.dup

      title = I18n.t("marketing.events_near_me")

      links = @event_categories.map do |event_category|
        @time_periods.map do |time_period|
          page_builder = Marketing::EventsPageBuilderFactory.build({
            city: nearby_city,
            event_category: event_category,
            time_period: time_period
          })
          {
            href: page_builder.build_path,
            title: page_builder.build_meta_title
          }
        end
      end.flatten

      links << {
        href: map_path,
        title: I18n.t("marketing.events_map"),
        turbo: false
      }

      links_groups << [ title, links ]
    end

    links_groups += @cities.map do |city|
      title = I18n.t("marketing.events_in_city", city: city.name)

      links = @event_categories.map do |event_category|
        @time_periods.map do |time_period|
          page_builder = Marketing::EventsPageBuilderFactory.build({
            city: city,
            event_category: event_category,
            time_period: time_period
          })
          {
            href: page_builder.build_path,
            title: page_builder.build_meta_title
          }
        end
      end.flatten

      links << {
        href: city_map_path(city_slug: city.slug),
        title: I18n.t("marketing.city_events_map", city: city.name),
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
      TimePeriod.new(nil, time_period_symbol)
    end
  end

  def load_event_categories(complete: false)
    event_category_symbols = complete ? EventCategory::SYMBOLS : [ :events ]
    @event_categories = event_category_symbols.map do |event_category_symbol|
      EventCategory.new(event_category_symbol)
    end
  end
end
