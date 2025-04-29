class CitySource < ApplicationRecord
  belongs_to :city
  belongs_to :source

  validates :name, presence: true, inclusion: { in: %w[ Eventbrite Luma Meetup MuenchenDe ] }
  validates :url, presence: true, uniqueness: true
  validates :url_params, presence: true

  def find_and_create_events!
    event_urls = events_finder.find_events(id)

    existing_event_urls = Event.where(city_source_id: id).pluck(:url)
    existing_archived_urls = ArchivedLink.where(url: event_urls).pluck(:url)

    existing_urls = existing_event_urls + existing_archived_urls
    event_urls -= existing_urls

    create_jobs = event_urls.map do |event_url|
      Event::CreateJob.new(city_source_id: id, url: event_url)
    end

    if create_jobs.any?
      ActiveJob.perform_all_later(create_jobs)
    end
  end

  def events_finder
    @events_finder ||= "Source::#{name}EventsFinder".constantize.new
  end
end
