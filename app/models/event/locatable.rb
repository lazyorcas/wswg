module Event::Locatable
  extend ActiveSupport::Concern

  included do
    belongs_to :location, optional: true

    scope :with_location_query, -> { where.not(location_query: nil) }
    scope :locatable, -> { where.missing(:location).with_location_query }
  end

  class_methods do
    def locate
      event_ids, queries = locatable.pluck(:id, :location_query).transpose
      results = Mapbox::Geocoding.batch_lookup(queries)

      event_ids.each_with_index do |event_id, index|
        location_attributes = results[index]
        next if location_attributes.nil?

        event = Event.find(event_id)

        event.location = Location.find_or_initialize_by(
          full_address: location_attributes[:full_address]
        )

        if event.location.new_record?
          event.location.city_id = event.city_source.city_id
          event.location.attributes = location_attributes
          event.location.save!
        end

        event.save!
      end
    end
  end
end
