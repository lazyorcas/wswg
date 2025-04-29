class Source < ApplicationRecord
  belongs_to :city

  validates :name, presence: true, inclusion: { in: %w[ Eventbrite Luma Meetup MuenchenDe ] }
  validates :url, presence: true, uniqueness: true

  def find_and_create_events!
    events_attributes = events_finder.find_events(id)

    existing_uids = Event.where(source_id: id).pluck(:uid)
    normalized_existing_ids = if name == "Luma"
      existing_uids.map { |uid| Source::Luma::EventsFinder.get_id(uid) }
    else
      existing_uids
    end

    archived_urls = ArchivedLink.where(url: events_attributes.map { |event_attributes| event_attributes[:url] }).pluck(:url)

    events_attributes = events_attributes.reject do |event_attributes|
      normalized_id = name == "Luma" ? Source::Luma::EventsFinder.get_id(event_attributes[:uid]) : event_attributes[:uid]

      normalized_existing_ids.include?(normalized_id) ||
      archived_urls.include?(event_attributes[:url])
    end

    create_jobs = events_attributes.map do |event_attributes|
      Event::CreateJob.new(
        source_id: id,
        uid: event_attributes[:uid],
        url: event_attributes[:url]
      )
    end

    if create_jobs.any?
      ActiveJob.perform_all_later(create_jobs)
    end
  end

  def events_finder
    @events_finder ||= "Source::#{name}::EventsFinder".constantize.new
  end
end
