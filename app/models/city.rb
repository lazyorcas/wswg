class City < ApplicationRecord
  include Sluggish
  include Localizable
  include Currency
  include Locatable
  include Scorable

  scope :enabled, -> {
    joins(:city_sources).where(city_sources: { enabled: true }).distinct
  }

  has_many :city_sources
  has_many :events, through: :city_sources
  has_many :city_languages
  has_many :languages, through: :city_languages
  has_many :users

  validates :name, presence: true
  validates_associated :time_zone
  validates :country_code,
    presence: true,
    inclusion: { in: ISO3166::Country.codes }

  def time_zone
    TimeZone.new(name: self[:time_zone])
  end

  def sluggish_field
    name
  end

  def localizable_field
    name
  end
end
