city_ids = City.where(name: [ "Singapore", "Barcelona", "Tokyo" ]).pluck(:id)

city_ids.each do |city_id|
  City::FindAndCreateEventsJob.perform_later(city_id)
end
