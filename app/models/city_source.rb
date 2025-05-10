class CitySource < ApplicationRecord
  include Availability
  include Scrapeable

  scope :enabled, -> { where(enabled: true) }

  belongs_to :city
  belongs_to :source

  has_many :events

  def self.find_by_names(city_name:, source_name:)
    city = City.find_by(name: city_name)
    source = Source.find_by(name: source_name)
    find_by(city: city, source: source)
  end

  def url
    @url ||= source.template_url % url_params.symbolize_keys
  end
end
