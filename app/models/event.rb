class Event < ApplicationRecord
  include Fetchable
  include Locatable
  include Searchable

  belongs_to :source
  belongs_to :city

  has_many :bookmarks, as: :bookmarkable
  has_many :seens, as: :seenable
  has_many :seen_users, through: :seens, source: :user

  validates :uid, uniqueness: { scope: :source_id }
  validates :url, presence: true

  validates :title, presence: true
  validates :description, presence: true
  validates :image_url, presence: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :price, presence: true

  validate :end_date_is_today_or_future, if: -> { city.present? }

  before_update -> { self.location = nil }, if: :location_query_changed?

  private

  def end_date_is_today_or_future
    today = Time.current.in_time_zone(city.time_zone).to_date

    if end_date < today.to_s
      errors.add(:end_date, "(#{end_date}) must be today (#{today}) or in the future")
    end
  end
end

# TODO: deduplicate events
# https://github.com/flori/amatch
# Match by title, location, date time range
