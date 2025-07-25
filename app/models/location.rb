class Location < ApplicationRecord
  include Locatable

  acts_as_mappable lng_column_name: :lon

  validates :full_address, presence: true, uniqueness: true

  def city_address
    full_address.split(",")[0...-1].join(",")
  end
end
