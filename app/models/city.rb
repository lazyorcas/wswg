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

  def names
    @names ||= [ name, self.alias ].compact
  end

  def downcased_names
    @downcased_names ||= names.map(&:downcase)
  end

  def precise?(query)
    query
      .downcase
      .gsub(/(#{downcased_names.join("|")})/, "")
      .gsub(",", "")
      .strip
      .present?
  end

  def contains?(query)
    downcased_query = query.downcase
    downcased_names.any? { |name| downcased_query.include?(name) }
  end

  private

  def set_slug
    self.slug = name.parameterize
  end
end
