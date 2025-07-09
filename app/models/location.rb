class Location < ApplicationRecord
  include Locatable

  acts_as_mappable default_units: :kms, default_formula: :sphere, lat_column_name: :lat, lng_column_name: :lon

  validates :full_address, presence: true, uniqueness: true
end
