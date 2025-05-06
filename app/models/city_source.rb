class CitySource < ApplicationRecord
  scope :enabled, -> { where(enabled: true) }

  belongs_to :city
  belongs_to :source

  def self.enable_by_city_names!(city_names)
    joins(:city).where(city: { name: city_names }).update_all(enabled: true)
  end

  def self.find_by_names(city_name:, source_name:)
    city = City.find_by(name: city_name)
    source = Source.find_by(name: source_name)
    find_by(city: city, source: source)
  end

  def url
    @url ||= source.template_url % url_params.symbolize_keys
  end
end
