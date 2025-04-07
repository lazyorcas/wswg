class City::FindAndCreateEventsJob < ApplicationJob
  queue_as :default

  def perform(city_id:)
    city = City.find(city_id)

    city.city_sources.find_each do |city_source|
      city_source.find_and_create_events!
    end
  end
end
