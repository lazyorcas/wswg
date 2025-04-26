class Location < ApplicationRecord
  include HasCoordinates

  # ordered by cost efficiency
  # Mapbox: 100,000 requests per month for free
  # Google: 10,000 requests per month for free
  GEOCODERS = [ Mapbox::Geocoding, Google::Geocoding ]
  MAX_DISTANCE_TO_CITY_IN_KM = 30

  belongs_to :city

  has_many :events

  validates :full_address, presence: true, uniqueness: true

  validate :validate_full_address_contains_city_name
  validate :validate_full_address_contains_more_than_city_name
  validate :validate_coordinates_are_close_to_city

  def self.find_or_create_by_query(query, city_id:)
    location = nil

    GEOCODERS.each do |geocoder|
      attributes = geocoder.lookup(query)
      next if attributes.blank?

      location = find_or_initialize_by(full_address: attributes[:full_address])
      break if location.persisted?

      location.city_id = city_id
      location.attributes = attributes

      if location.valid?
        location.save
        break
      else
        location = nil
      end
    end

    location
  end

  private

  def validate_full_address_contains_city_name
    return if city.names.any? { |name| full_address.include?(name) }

    errors.add(:full_address, :invalid, message: "does not contain #{city.name}")
  end

  def validate_full_address_contains_more_than_city_name
    return if city.names.all? { |name| full_address != name }

    errors.add(:full_address, :invalid, message: "only contains #{city.name}")
  end

  def validate_coordinates_are_close_to_city
    distance_to_city_in_km = Geospatial.distance_in_km_between(city.coordinates_h, coordinates_h)
    return if distance_to_city_in_km <= MAX_DISTANCE_TO_CITY_IN_KM

    errors.add(:coordinates, :invalid, message: "are too far from #{city.name}")
  end
end
