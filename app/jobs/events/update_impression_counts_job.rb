class Events::UpdateImpressionCountsJob < ApplicationJob
  queue_as :default
  queue_with_priority 2

  def perform(time_ago: 1.hour)
    Ahoy::Event
      .where(name: "Impression")
      .group("properties->>'event_id'")
      .where(time: time_ago.ago..)
      .count
      .find_each do |event_id, count|
        Event.find(event_id).update!(impression_count: count)
      end
  end
end
