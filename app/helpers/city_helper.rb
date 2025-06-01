module CityHelper
  def title_generator
    @title_generator ||= SEO::City::TitleGenerator.new
  end

  def build_city_meta_title(city, time_period_symbol)
    title_generator.generate_title(city, time_period_symbol)
  end

  def build_city_title(city, time_period_symbol)
    title_generator.generate_default_title(city, time_period_symbol)
  end

  def build_city_meta_description(city, time_period)
    description = "What's happening in #{city.name} #{time_period.to_s}? Discover local events from Luma, Meetup, Eventbrite, and Ticketmaster in one place." # rubocop:disable Lint/RedundantStringCoercion
    description.gsub!(/  +/, " ")
    description.gsub!(/ \?/, "?")
    description
  end

  def build_city_description(city, time_period)
    description = "What's happening in #{city.name} #{time_period.to_s} #{build_time_range(time_period)}? Discover local events from Luma, Meetup, Eventbrite, and Ticketmaster in one place." # rubocop:disable Lint/RedundantStringCoercion
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

  def build_time_range(time_period)
    if time_period.today? || time_period.tonight? || time_period.tomorrow?
      start_date = time_period.start_date
      "(<time datetime=\"#{start_date.strftime("%Y-%m-%d")}\">#{start_date.strftime("%B %d")}</time>)"
    elsif time_period.all?
      nil
    else
      start_date = time_period.start_date
      end_date = time_period.end_date
      "(<time datetime=\"#{start_date.strftime("%Y-%m-%d")}\">#{start_date.strftime("%B %d")}</time> - <time datetime=\"#{end_date.strftime("%Y-%m-%d")}\">#{end_date.strftime("%B %d")}</time>)"
    end
  end

  def build_event_cache_key(event)
    key_array = [ dom_id(event), @city.time_zone.current_date.to_s ]
    if browser.bot?
      key_array << "bot"
    end
    key_array
  end
end
