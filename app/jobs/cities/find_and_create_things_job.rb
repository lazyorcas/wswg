class Cities::FindAndCreateThingsJob < ApplicationJob
  queue_with_priority 2

  HOURS_TO_FIND = [ 7, 12, 17, 22 ]
  PROXY_HOUR_TO_FIND = 22

  def perform
    City.includes(:sources).find_each do |city|
      current_hour = Time.current.in_time_zone(city.time_zone).hour

      if HOURS_TO_FIND.include?(current_hour)
        city.sources.each do |source|
          # proxy is expensive, so we only use it once a day
          next if source.proxy? && current_hour != PROXY_HOUR_TO_FIND

          Source::FindAndCreateThingsJob.perform_later(source.id)
        end
      end
    end
  end
end
