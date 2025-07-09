module Locatable
  extend ActiveSupport::Concern

  included do
    validates :lat, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
    validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  end

  def coordinates
    @coordinates ||= { lat: lat, lon: lon }
  end

  def coordinates_arr
    @coordinates_arr ||= [ lat, lon ]
  end
end
