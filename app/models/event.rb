class Event < ApplicationRecord
  include Fetchable
  include Locatable

  scope :search_import, -> { includes(:city_source) }
  searchkick

  belongs_to :city_source

  validates :uid, uniqueness: { scope: :city_source_id }
  validates :url, presence: true

  validates :title, presence: true
  validates :description, presence: true
  validates :image_url, presence: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :price, presence: true

  validate :start_date_is_today_or_future

  before_update -> { self.location = nil }, if: :location_query_changed?

  def search_data
    {
      title: title,
      description: description,
      start_date: start_date,
      end_date: end_date,
      start_time: start_time,
      end_time: end_time,
      price: price,
      city_id: city_source.city_id
    }
  end

  private

  def start_date_is_today_or_future
    errors.add(:start_date, "must be today or in the future") if start_date < today
  end

  def today
    Date.today.in_time_zone(city_source.city.time_zone)
  end
end
