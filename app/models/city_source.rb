class CitySource < ApplicationRecord
  include Scrapeable

  scope :enabled, -> { where(enabled: true) }

  belongs_to :city
  belongs_to :source

  def self.find_by_names(city_name:, source_name:)
    city = City.find_by(name: city_name)
    source = Source.find_by(name: source_name)
    find_by(city: city, source: source)
  end

  def self.enable(city_names: nil, source_names: nil)
    city_ids = city_names.present? ?
      City.where(name: city_names).pluck(:id) :
      City.pluck(:id)

    source_ids = source_names.present? ?
      Source.where(name: source_names).pluck(:id) :
      Source.pluck(:id)

    city_ids.each do |city_id|
      source_ids.each do |source_id|
        find_by(city_id: city_id, source_id: source_id).update!(enabled: true)
      end
    end
  end

  def self.disable(city_names: nil, source_names: nil)
    city_ids = city_names.present? ?
      City.where(name: city_names).pluck(:id) :
      City.pluck(:id)

    source_ids = source_names.present? ?
      Source.where(name: source_names).pluck(:id) :
      Source.pluck(:id)

    city_ids.each do |city_id|
      source_ids.each do |source_id|
        find_by(city_id: city_id, source_id: source_id).update!(enabled: false)
      end
    end
  end

  def url
    @url ||= source.template_url % url_params.symbolize_keys
  end
end
