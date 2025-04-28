module Event::Locatable
  extend ActiveSupport::Concern

  included do
    belongs_to :location, optional: true
    scope :located, -> { where.not(location_id: nil) }
  end

  def queue_locate(location_query)
    Event::LocateJob.perform_later(id, location_query: location_query)
  end
end
