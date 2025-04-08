class Event < ApplicationRecord
  include Fetchable
  include Locatable

  scope :search_import, -> { includes(:city_source) }
  searchkick \
    searchable: [ "title", "description" ],
    filterable: [ "start_date", "end_date", "start_time", "end_time", "price", "city_source.city_id" ]

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
end
