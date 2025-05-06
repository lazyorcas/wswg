class LocationQuery < ApplicationRecord
  # ordered by cost efficiency
  # Mapbox: 100,000 requests per month for free
  # Google: 10,000 requests per month for free
  GEOCODERS_CLASSES = [ Mapbox::GeocodingClient, Google::GeocodingClient ]

  belongs_to :location, optional: true

  validates :query, presence: true, uniqueness: true

  after_commit :query!, if: :should_query?

  def query=(value)
    super(value.strip)
  end

  def should_query?
    (query_changed? || query_previously_changed?) && query.present? && precise?(query)
  end

  def query!
    location_attributes = nil

    GEOCODERS_CLASSES.each do |geocoder_class|
      geocoder = geocoder_class.new
      _location_attributes = geocoder.lookup(query)

      if _location_attributes.present? && precise?(_location_attributes[:full_address])
        location_attributes = _location_attributes
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
    save!
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
