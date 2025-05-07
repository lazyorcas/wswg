class City < ApplicationRecord
  include Sluggish
  include Locatable
  include Scorable
  include Availability
  include Scrapeable

  has_many :city_sources
  has_many :city_languages
  has_many :languages, through: :city_languages
  has_many :events, through: :city_sources
  has_many :users

  validates :name, presence: true
  validates_associated :time_zone
  validates :country_code,
    presence: true,
    inclusion: { in: ISO3166::Country.codes }
  validates :currency,
    presence: true,
    inclusion: { in: Money::Currency.table.keys.map(&:to_s).map(&:upcase) }

  def time_zone
    TimeZone.new(name: self[:time_zone])
  end

  def sluggish_field
    name
  end
end
