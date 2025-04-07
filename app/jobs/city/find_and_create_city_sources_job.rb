class CitySources::FindAndCreateCitySourcesJob < ApplicationJob
  queue_as :default

  def perform(city_id)
    city = City.find(city_id)

    Sources.find_ech do |source|
      log "Finding \"#{city.name}\" on \"#{source.homepage_url}\""

      begin
        source.find_and_create_city_source!(city.id)
        log "Created!"
      rescue => e
        log_error e.message
      end
    end
  end
end
