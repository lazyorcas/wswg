class Event < ApplicationRecord
  include Fetchable
  include Searchable

  belongs_to :city_source

  validates :uid, uniqueness: { scope: :city_source_id }
  validates :url, presence: true

  validates :data, presence: true

  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :price, presence: true
end
