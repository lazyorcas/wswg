class Source < ApplicationRecord
  include CityUrlFindable

  validates :homepage_url, presence: true, uniqueness: true
  validates :icon_url, presence: true
end
