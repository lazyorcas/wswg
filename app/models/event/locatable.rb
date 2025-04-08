module Event::Locatable
  extend ActiveSupport::Concern

  included do
    belongs_to :location, optional: true

    scope :with_location_query, -> { where.not(location_query: nil) }
    scope :locatable, -> { where.missing(:location).with_location_query }
  end

  def self.locate
    queries = locatable.map(&:location_query)
    results = Mapbox::Geocoding.batch_lookup(queries)

    locatable.each_with_index do |event, index|
      location_attributes = results[index]

      event.location = Location.find_or_initialize_by(
        full_address: location_attributes[:full_address]
      )

      if event.location.new_record?
        event.location.attributes = location_attributes
        event.location.save!
      end

      event.save!
    end
  end
end
