class Event < ApplicationRecord
  SIMILARITY_THRESHOLD = 0.9

  include Fetchable
  include Locatable

  belongs_to :source
  belongs_to :city

  has_many :bookmarks, as: :bookmarkable
  has_many :seens, as: :seenable
  has_many :seen_users, through: :seens, source: :user

  validates :uid, presence: true, uniqueness: { scope: :source_id }
  validates :url, presence: true

  validates :title, presence: true
  validates :description, presence: true
  validates :image_url, presence: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  with_options on: :create do
    validate :validate_url_found
    validate :validate_end_date_is_today_or_future, if: -> { end_date.present? }
    validate :validate_not_duplicated, if: -> { location_id.present? && start_date.present? && end_date.present? && start_time.present? }
  end

  validate :validate_start_date_is_before_or_same_as_end_date, if: -> { start_date.present && end_date.present? }

  before_update -> { self.location = nil }, if: :location_query_changed?
  before_save -> { self.end_time = nil }, if: -> { end_time.blank? || start_time == end_time }

  def end_date_is_today_or_future?
    end_date >= today.to_s
  end

  def start_date_is_before_or_same_as_end_date?
    start_date <= end_date
  end

  def duplicated?
    similar_events = Event.where(
      city_id: city_id,
      location_id: location_id,
      start_date: start_date,
      start_time: start_time,
      end_date: end_date,
      end_time: end_time
    ).excluding(self)

    similar_events.any? do |event|
      title.jarowinkler_similar(event.title) >= SIMILARITY_THRESHOLD
    end
  end

  private

  def validate_url_found
    return if found?

    errors.add(:url, :not_found_or_expired)
  end

  def validate_end_date_is_today_or_future
    return if end_date_is_today_or_future?

    errors.add(:end_date, :invalid, message: "must be today (#{today}) or in the future")
  end

  def validate_start_date_is_before_or_same_as_end_date
    return if start_date_is_before_or_same_as_end_date?

    errors.add(:start_date, :invalid, message: "must be before end date")
  end

  def validate_not_duplicated
    return if !duplicated?

    errors.add(:base, :duplicated, message: "already exists in this date time range, location, and title.")
  end

  def today
    @today ||= Time.current.in_time_zone(city.time_zone).to_date
  end
end
