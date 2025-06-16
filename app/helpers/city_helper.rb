module CityHelper
  def city_title_generator
    @city_title_generator ||= SEO::City::TitleGenerator.new
  end

  def build_city_meta_title(city, time_period_symbol)
    city_title_generator.generate_title(city, time_period_symbol)
  end

  def build_city_title(city, time_period_symbol)
    city_title_generator.generate_default_title(city, time_period_symbol)
  end

  def build_city_description(city, time_period)
    description = "What's happening in #{city.name} #{time_period.all? ? nil : time_period}? Browse and search for local events, meetups, and concerts from Luma, Meetup, Eventbrite, and Ticketmaster in one place."
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
    if browser.bot?
      key_array << "bot"
    end
    key_array
  end
end
