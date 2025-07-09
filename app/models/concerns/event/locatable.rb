module Event::Locatable
  extend ActiveSupport::Concern

  MAX_DISTANCE_TO_CITY = 50
  DISTANCE_UNIT = "km"

  included do
    belongs_to :location, optional: true
    scope :located, -> { where.not(location_id: nil) }

    acts_as_mappable through: :location, lat_column_name: :lat, lng_column_name: :lon
  end

  def locatable?
    location_query.present?
  end

  def locate
    _location_query = LocationQuery.find_or_create_by(query: location_query)
    return if _location_query.location_id.blank?

    coordinates = _location_query.location.coordinates
    city_coordinates = city.coordinates

    distance_from_city = Geospatial.distance_in_km_between(coordinates, city_coordinates)

    if distance_from_city <= MAX_DISTANCE_TO_CITY
      self.location_id = _location_query.location_id
    end
  end
end
