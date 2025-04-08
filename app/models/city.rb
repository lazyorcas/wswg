class City < ApplicationRecord
  has_many :city_sources

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :time_zone,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  before_validation :set_slug

  private

  def set_slug
    self.slug = name.parameterize
  end
end
