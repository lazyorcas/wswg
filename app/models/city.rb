class City < ApplicationRecord
  has_many :city_sources

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug

  private

  def set_slug
    self.slug = name.parameterize
  end
end
