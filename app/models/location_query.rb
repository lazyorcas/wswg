class LocationQuery < ApplicationRecord
  # ordered by cost efficiency
  # Mapbox: 100,000 requests per month for free
  # Google: 10,000 requests per month for free
  GEOCODERS = [ Mapbox::Geocoding, Google::Geocoding ]

  belongs_to :location, optional: true

  validates :query, presence: true, uniqueness: true

  before_validation -> { self.query = query.strip }
  before_create :geocode, if: :precise?

  def geocode
    GEOCODERS.each do |geocoder|
      attributes = geocoder.lookup(query)
      next if attributes.blank?

      location = Location.find_or_initialize_by(full_address: attributes[:full_address])
      break if location.persisted?

      location.attributes = attributes

      location.save
      self.location = location
      break
    end
  end

  private

  def precise?
    !city?
  end

  def city?
    geographer.true_or_false?(
      location: query,
      question: "Is the location a city?"
    )
  end

  def geographer
    @geographer ||= OpenAI::Assistants::Geographer.new
  end
end
