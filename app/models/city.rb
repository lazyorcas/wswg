class City < ApplicationRecord
  include Scorable
  include HasCoordinates

  scope :enabled, -> { where(enabled: true) }

  has_many :users

  has_many :city_sources

  has_many :city_languages
  has_many :languages, through: :city_languages

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates_associated :time_zone

  validates :currency,
    presence: true,
    inclusion: { in: Money::Currency.table.keys.map(&:to_s).map(&:upcase) }

  before_validation :set_slug

  def time_zone
    TimeZone.new(name: self[:time_zone])
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
