class Location < ApplicationRecord
  include HasCoordinates

  validates :full_address, presence: true, uniqueness: true
end
