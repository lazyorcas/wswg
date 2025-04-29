class CitySource < ApplicationRecord
  belongs_to :city
  belongs_to :source

  validates :url_params, presence: true

  def url
    @url ||= source.template_url % url_params
  end

  def find_and_create_events!
    event_urls = events_finder.find_events(id)

    # TODO: Luma urls are not unique
    existing_event_urls = Event.where(url: event_urls).pluck(:url)
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
    @events_finder ||= "Source::#{source.name}EventsFinder".constantize.new
  end
end
