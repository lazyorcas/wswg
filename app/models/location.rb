class Location < ApplicationRecord
  belongs_to :city

  validates :full_address, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
