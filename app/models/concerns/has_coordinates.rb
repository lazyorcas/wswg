module HasCoordinates
  extend ActiveSupport::Concern

  included do
    validates :latitude, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
    validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  end

  def coordinates
    @coordinates ||= [ longitude, latitude ]
  end

  def coordinates_h
    @coordinates_h ||= {
      latitude: latitude,
      longitude: longitude
    }
  end
end
