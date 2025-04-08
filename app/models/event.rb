class Event < ApplicationRecord
  include Fetchable
  include Locatable

  searchkick \
    searchable: [ :title, :description ],
    filterable: [ :start_date, :end_date, :start_time, :end_time, :price, :city_id ]

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

  private

  def start_date_is_today_or_future
    today = Date.today.in_time_zone(city.time_zone)

    if start_date < today
      errors.add(:start_date, "must be today or in the future")
    end
  end

  def city_id_same_as_city_source_city_id
    if city_id != city_source.city_id
      errors.add(:city_id, "must be the same as the city_source's city_id")
    end
  end
end
