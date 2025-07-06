module NearbyHelper
  def nearby_title_generator
    @nearby_title_generator ||= SEO::Nearby::TitleGenerator.new
  end

  def build_nearby_meta_title(event_category_symbol, time_period_symbol)
    nearby_title_generator.generate_meta_title(event_category_symbol, time_period_symbol)
  end

  def build_nearby_title(event_category_symbol, time_period_symbol)
    nearby_title_generator.generate_title(event_category_symbol, time_period_symbol)
  end

  def build_nearby_description(event_category_symbol, time_period)
    description = if event_category_symbol == :events
      "Browse and search for nearby events, meetups, and concerts #{time_period.all? ? nil : time_period} from multiple sources in one place."
    else
      "Browse and search for nearby #{EventCategory::SYMBOL_TO_STRING_MAPPING[event_category_symbol]} #{time_period.all? ? nil : time_period} from multiple sources in one place."
    end
    description.gsub!(/  +/, " ")
    description.gsub!(/ \?/, "?")
    description
  end

  def build_nearby_events_path(time_period_slug:, **args)
    if time_period_slug.nil?
      all_nearby_events_path(**args)
    else
      nearby_events_path(time_period_slug: time_period_slug, **args)
    end
  end
end
