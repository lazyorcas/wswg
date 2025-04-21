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

  validate :end_date_is_today_or_future, if: -> { city_id.present? }
  validate :date_time_range_and_location_are_unique, if: -> { location_id.present? && start_date.present? && start_time.present? && end_date.present? && end_time.present? }

  before_update -> { self.location = nil }, if: :location_query_changed?

  private

  def end_date_is_today_or_future
    today = Time.current.in_time_zone(city.time_zone).to_date

    if end_date < today.to_s
      errors.add(:end_date, "(#{end_date}) must be today (#{today}) or in the future")
    end
  end

  def date_time_range_and_location_are_unique
    if Event.exists?(
      location_id: location_id,
      start_date: start_date,
      start_time: start_time,
      end_date: end_date,
      end_time: end_time
    )
      errors.add(:base, "Event already exists in this date time range (#{start_date} #{start_time} - #{end_date} #{end_time}) and location #{location_id}")
    end
  end
end
