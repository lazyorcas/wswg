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

  City
    .enabled
    .order(:name)
    .each do |city|
      add events_today_path(city_slug: city.slug), priority: 0.9, changefreq: "daily"
      add events_tomorrow_path(city_slug: city.slug), priority: 0.9, changefreq: "daily"
      add events_this_week_path(city_slug: city.slug), priority: 0.9, changefreq: "daily"
      add events_next_week_path(city_slug: city.slug), priority: 0.9, changefreq: "daily"
    end
end
