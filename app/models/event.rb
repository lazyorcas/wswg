class Event < ApplicationRecord
  include Fetchable
  include Locatable

  default_scope { where(start_date: { gte: Date.yesterday.to_s }) }
  scope :search_import, -> { includes(:city_source) }

  searchkick \
    searchable: [ "title", "description", "city_source.city_id" ],
    filterable: [ "start_date", "end_date", "start_time", "end_time", "price", "location_id" ]

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

  def should_index?
    start_date >= Date.yesterday.to_s
  end
end
