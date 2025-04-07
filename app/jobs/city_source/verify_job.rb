class CitySource::VerifyJob < ApplicationJob
  queue_as :default

  def perform(city_source_id)
    city_source = CitySource.find(city_source_id)
    city_source.verify!
  end
end
