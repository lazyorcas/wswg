City.pluck(:id).each do |city_id|
  City::FindAndCreateThingsJob.perform_later(city_id)
end
