class City < ApplicationRecord
  include HasCoordinates

  has_many :sources

  has_many :city_languages
  has_many :languages, through: :city_languages

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :time_zone,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:tzinfo).map(&:name) }
  validates :currency,
    presence: true,
    inclusion: { in: Money::Currency.table.keys.map(&:to_s).map(&:upcase) }

  before_validation :set_slug

  end

  def precise?(query)
    query
      .downcase
      .gsub(name.downcase, "")
      .gsub(self.alias&.downcase || "", "")
      .gsub(",", "")
      .strip
      .present?
  end

  def contains?(query)
    downcased_query = query.downcase
    downcased_query.include?(name.downcase) ||
      (
        self.alias.present? &&
        downcased_query.include?(self.alias.downcase)
      )
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
