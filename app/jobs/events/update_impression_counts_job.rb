class Events::UpdateImpressionCountsJob < ApplicationJob
  queue_as :default
  queue_with_priority 2

  def perform(time_ago: 1.hour)
    Ahoy::Event
      .where(name: "Impression")
      .where("users.id IS NULL OR users.business_id IS NULL")
      .where(time: time_ago.ago..)
      .group("properties->>'event_id'")
      .count
      .each do |event_id, count|
        event = Event.find(event_id)
        impression_count = event.impression_count || 0
        impression_count += count
        event.update!(impression_count: impression_count)
      end
  end
end
