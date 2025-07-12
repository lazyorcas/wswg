# temporary job
class Events::FinalizeJob < ApplicationJob
  LIMIT = 500

  queue_as :default
  queue_with_priority 10
  limits_concurrency to: 1, key: ->(*) { self.class.name }

  def perform
    jobs = Event
      .joins(:city_source)
      .joins(:city)
      .where(cities: { name: "Singapore" })
      .where("CONCAT(start_date, ' ', start_time) < TO_CHAR(NOW() AT TIME ZONE cities.time_zone, 'YYYY-MM-DD HH24:MI:SS')")
      .where("attendees_count_finalized_at IS NULL OR organizer_url IS NULL")
      .order(id: :desc)
      .limit(LIMIT)
      .map do |event|
        Event::FinalizeJob.new(event.id)
      end

    ActiveJob.perform_all_later(jobs)
  end
end
