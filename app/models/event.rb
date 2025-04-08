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
end
