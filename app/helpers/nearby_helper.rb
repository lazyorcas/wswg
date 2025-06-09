module NearbyHelper
  def nearby_title_generator
    @nearby_title_generator ||= SEO::Nearby::TitleGenerator.new
  end

  def build_nearby_meta_title(time_period_symbol)
    nearby_title_generator.generate_meta_title(time_period_symbol)
  end

  def build_nearby_title(time_period_symbol)
    nearby_title_generator.generate_title(time_period_symbol)
  end

  def build_nearby_description(time_period)
    description = "What's happening near me #{time_period.all? ? nil : time_period}? Discover local events from Luma, Meetup, Eventbrite, and Ticketmaster in one place."
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
