class LocationQuery < ApplicationRecord
  belongs_to :location

  validates :query, presence: true, uniqueness: true
end
