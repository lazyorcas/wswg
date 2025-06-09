SitemapGenerator::Interpreter.send :include, CityHelper
SitemapGenerator::Interpreter.send :include, NearbyHelper

SitemapGenerator::Sitemap.default_host = "https://#{ENV["HOST_NAME"]}"
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host

  add local_events_directory_path, priority: 0.8, changefreq: "daily"

  cities = City.enabled
  TimePeriod::SYMBOLS.each do |time_period_symbol|
    change_freq = case time_period_symbol
    when :all, :today, :tonight, :tomorrow, :this_week
      "hourly"
    when :this_weekend, :next_week, :next_weekend
      "daily"
    else
      "weekly"
    end

    add build_nearby_events_path(
      time_period_slug: TimePeriod.slugify(time_period_symbol)
    ),
    priority: 0.9,
    changefreq: change_freq

    cities.each do |city|
      add build_city_events_path(
        city_slug: city.slug,
        time_period_slug: TimePeriod.slugify(time_period_symbol)
      ),
      priority: 0.9,
      changefreq: change_freq
    end
  end
end
