class Source < ApplicationRecord
  belongs_to :city

  validates :name, presence: true, inclusion: { in: %w[ Eventbrite Luma Meetup MuenchenDe ] }
  validates :url, presence: true, uniqueness: true

  validates :thing_type, presence: true, inclusion: { in: %w[ Event ] }

  def find_and_create_things!
    things_attributes = things_finder.find_things(id)

    existing_uids = thing_model.where(source_id: id).pluck(:uid)
    normalized_existing_ids = if name == "Luma"
      existing_uids.map { |uid| Source::Luma::ThingsFinder.get_id(uid) }
    else
      existing_uids
    end

    archived_urls = ArchivedLink.where(url: things_attributes.map { |thing_attributes| thing_attributes[:url] }).pluck(:url)

    things_attributes = things_attributes.reject do |thing_attributes|
      normalized_id = name == "Luma" ? Source::Luma::ThingsFinder.get_id(thing_attributes[:uid]) : thing_attributes[:uid]

      normalized_existing_ids.include?(normalized_id) ||
      archived_urls.include?(thing_attributes[:url])
    end

    create_jobs = things_attributes.map do |thing_attributes|
      create_thing_job_class.new(
        source_id: id,
        city_id: city_id,
        uid: thing_attributes[:uid],
        url: thing_attributes[:url]
      )
    end

    if create_jobs.any?
      ActiveJob.perform_all_later(create_jobs)
    end
  end

  def things_finder
    @things_finder ||= "Source::#{name}::ThingsFinder".constantize.new
  end

  def thing_model
    thing_type.constantize
  end

  def create_thing_job_class
    "#{thing_type}::CreateJob".constantize
  end
end
