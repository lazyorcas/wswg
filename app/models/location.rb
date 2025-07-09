class Location < ApplicationRecord
  include Locatable

  acts_as_mappable

  validates :full_address, presence: true, uniqueness: true
end
