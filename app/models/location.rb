class Location < ApplicationRecord
  include Locatable

  acts_as_mappable lng_column_name: :lon

  validates :full_address, presence: true, uniqueness: true
end
