module CityHelper
  def city_title_generator
    @city_title_generator ||= SEO::City::TitleGenerator.new
  end

  def build_city_meta_title(city_name, event_category_symbol, time_period_symbol)
    city_title_generator.generate_meta_title(city_name, event_category_symbol, time_period_symbol)
  end

  def build_city_title(city_name, event_category_symbol, time_period_symbol)
    city_title_generator.generate_title(city_name, event_category_symbol, time_period_symbol)
  end

  def build_city_description(city_name, event_category_symbol, time_period)
    description = if event_category_symbol == :events
      "Browse and search for events, meetups, and concerts in #{city_name} from multiple platforms in one place."
    else
      "Browse and search for #{EventCategory::SYMBOL_TO_STRING_MAPPING[event_category_symbol]} in #{city_name} #{time_period.all? ? nil : time_period} from multiple platforms in one place."
    end
    description.gsub!(/  +/, " ")
    description.gsub!(/ \?/, "?")
    description
  end

  def build_city_events_path(time_period_slug:, **args)
    if time_period_slug.nil?
      all_city_events_path(**args)
    else
      city_events_path(time_period_slug: time_period_slug, **args)
    end
  end

  def build_event_cache_key(event)
    key_array = [ dom_id(event), event.updated_at.to_s, @city.time_zone.current_date.to_s ]
    key_array << "bot" if browser.bot?
    key_array
  end
end
