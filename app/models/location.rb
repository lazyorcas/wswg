class Location < ApplicationRecord
  include HasCoordinates

  # ordered by cost efficiency
  # Mapbox: 100,000 requests per month for free
  # Google: 10,000 requests per month for free
  GEOCODERS = [ Mapbox::Geocoding, Google::Geocoding ]

  belongs_to :city

  validates :full_address, presence: true, uniqueness: true

  def self.find_or_create_by_query(query, city_id:)
    location_attributes = nil

    city = City.find(city_id)

    GEOCODERS.each do |geocoder|
      data = geocoder.lookup(query)

      # Mapbox sometimes returns the city name as the full address.
      if data.present? && data[:full_address] != city.name
        location_attributes = data
        break
      end
    end

    return if location_attributes.blank?

    location = find_or_initialize_by(full_address: location_attributes[:full_address])

    if location.new_record?
      location.city_id = city_id
      location.attributes = location_attributes
      location.save
    end

    location
  end
end
