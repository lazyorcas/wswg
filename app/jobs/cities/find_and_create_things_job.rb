class Cities::FindAndCreateThingsJob < ApplicationJob
  queue_with_priority 1

  HOURS_TO_FIND = [ 7, 12, 17, 22 ]

  def perform
    City.find_each do |city|
      current_hour = Time.current.in_time_zone(city.time_zone).hour

      if HOURS_TO_FIND.include?(current_hour)
        city.source_ids.each do |source_id|
          Source::FindAndCreateThingsJob.perform_later(source_id)
        end
      end
    end
  end
end
