module Event::Locatable
  extend ActiveSupport::Concern

  MAX_DISTANCE_TO_CITY = 30
  DISTANCE_UNIT = "km"

  included do
    belongs_to :location, optional: true
    scope :located, -> { where.not(location_id: nil) }
  end

  def queue_locate(location_query)
    Event::LocateJob.perform_later(id, location_query: location_query)
  end
end
