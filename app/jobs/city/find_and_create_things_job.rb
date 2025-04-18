class City::FindAndCreateThingsJob < ApplicationJob
  queue_with_priority 2

  def perform(id)
    city = City.find(id)
    city.source_ids.each do |source_id|
      Source::FindAndCreateThingsJob.perform_later(source_id)
    end
  end
end
