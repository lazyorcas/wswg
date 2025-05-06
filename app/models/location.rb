class Location < ApplicationRecord
  include Locatable

  validates :full_address, presence: true, uniqueness: true
end
