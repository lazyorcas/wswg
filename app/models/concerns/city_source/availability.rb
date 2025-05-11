module CitySource::Availability
  extend ActiveSupport::Concern

  class_methods do
    def enable(city_names: nil, source_names: nil)
      city_ids = find_city_ids_by_city_names(city_names)
      source_ids = find_source_ids_by_source_names(source_names)

      city_ids.each do |city_id|
        source_ids.each do |source_id|
          city_source = find_by(city_id: city_id, source_id: source_id)
          next if city_source.nil?

          city_source.update!(enabled: true)
        end
      end
    end

    def disable(city_names: nil, source_names: nil)
      city_ids = find_city_ids_by_city_names(city_names)
      source_ids = find_source_ids_by_source_names(source_names)

      city_ids.each do |city_id|
        source_ids.each do |source_id|
          city_source = find_by(city_id: city_id, source_id: source_id)
          next if city_source.nil?

          city_source.update!(enabled: false)
        end
      end
    end

    private

    def find_city_ids_by_city_names(city_names, all_if_nil: true)
      if city_names.present?
        City.where(name: city_names).pluck(:id)
      elsif all_if_nil
        City.pluck(:id)
      else
        []
      end
    end

    def find_source_ids_by_source_names(source_names, all_if_nil: true)
      if source_names.present?
        Source.where(name: source_names).pluck(:id)
      elsif all_if_nil
        Source.pluck(:id)
      else
        []
      end
    end
  end

  included do
    scope :enabled, -> { where(enabled: true) }
  end
end
