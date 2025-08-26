class Events::UpdateImpressionCountsJob < ApplicationJob
  queue_as :default
  queue_with_priority 2

  def perform(time_ago: 1.hour)
    Ahoy::Event
      .where(name: "Impression")
      .where("user_id != 1 OR user_id IS NULL")
      .group("properties->>'event_id'")
      .where(time: time_ago.ago..)
      .count
      .each do |event_id, count|
        Event.find(event_id).update!(impression_count: count)
      end
  end
end
