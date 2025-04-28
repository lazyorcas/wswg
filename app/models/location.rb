class Location < ApplicationRecord
  include HasCoordinates

  MAX_DISTANCE_TO_CITY_IN_KM = 30

  validates :full_address, presence: true, uniqueness: true
end
