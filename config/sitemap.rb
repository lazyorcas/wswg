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

  events_directory_builder = Marketing::EventsDirectoryBuilder.new
  links_groups = events_directory_builder.build_links_attributes(complete: true)
  links_groups.each do |_, links|
    links.each do |link|
      add link[:href], priority: 0.9, changefreq: "daily"
    end
  end
end
