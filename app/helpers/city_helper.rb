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

  def build_city_description(city, time_period)
    description = "What's happening in #{city.name} #{time_period.to_s} #{time_period.date_range_s.present? ? "(" + time_period.date_range_s + ")" : ""}? Discover local events from Luma, Meetup, Eventbrite, and Ticketmaster." # rubocop:disable Lint/RedundantStringCoercion
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
end
