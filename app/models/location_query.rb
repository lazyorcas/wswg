class LocationQuery < ApplicationRecord
  # ordered by cost efficiency
  # Mapbox: 100,000 requests per month for free
  # Google: 10,000 requests per month for free
  GEOCODERS = [ Mapbox::Geocoding, Google::Geocoding ]

  belongs_to :location, optional: true

  validates :query, presence: true, uniqueness: true

  before_validation -> { self.query = query.strip }
  before_create :geocode!, if: -> { precise?(query) }

  def geocode!
    location_attributes = nil

    GEOCODERS.each do |geocoder|
      entry = geocoder.lookup(query)

      if entry.present? && precise?(entry[:full_address])
        location_attributes = entry
        break
      end
    end

    return if location_attributes.blank?

    location = Location.find_or_initialize_by(full_address: location_attributes[:full_address])

    if location.new_record?
      location.attributes = location_attributes
      location.save!
    end

    self.location = location
  end

  private

  def precise?(query)
    !city?(query)
  end

  def city?(query)
    geographer.true_or_false?(
      location: query,
      question: "Is the location a city?"
    )
  end

  def geographer
    @geographer ||= OpenAI::Assistants::Geographer.new
  end
end
