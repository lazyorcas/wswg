class Event::ExtractOrganizerDataJob < ApplicationJob
  queue_as :default
  queue_with_priority 10
  limits_concurrency to: 5, key: ->(*) { self.class.name }

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 5.minutes, attempts: 3

  def perform(event_id)
    event = Event.find(event_id)
    organizer_data = event.extract_organizer_data_from_markdown
    puts organizer_data
    event.update!(
      organizer_url: organizer_data["organizer_url"],
      organizer_name: organizer_data["organizer_name"]
    )
  end
end

# jobs = City.find_by_name("Singapore").events.where(organizer_url: nil).pluck(:id).map do |event_id|
#   Event::ExtractOrganizerDataJob.new(event_id)
# end
# ActiveJob.perform_all_later(jobs)
