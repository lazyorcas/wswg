class Events::FinalizeAttendeesCountsJob < ApplicationJob
  LIMIT = 100

  queue_as :default
  queue_with_priority 10
  limits_concurrency to: 1, key: ->(*) { self.class.name }

  def perform
    jobs = Event
      .joins(:city_source)
      .joins(:city)
      .joins(:source)
      .where("start_date_time < TO_CHAR(NOW() AT TIME ZONE cities.time_zone, 'YYYY-MM-DD HH24:MI:SS')")
      .where(sources: { events_finalizable: true })
      .where(attendees_count_finalized_at: nil)
      .order(id: :desc)
      .limit(LIMIT)
      .map do |event|
        Event::FinalizeAttendeesCountJob.new(event.id)
      end

    ActiveJob.perform_all_later(jobs)
  end
end
