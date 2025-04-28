class City < ApplicationRecord
  include HasCoordinates

  belongs_to :time_zone

  has_many :sources

  has_many :city_languages
  has_many :languages, through: :city_languages

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  validates :currency,
    presence: true,
    inclusion: { in: Money::Currency.table.keys.map(&:to_s).map(&:upcase) }

  before_validation :set_slug

  private

  def set_slug
    self.slug = name.parameterize
  end
end
