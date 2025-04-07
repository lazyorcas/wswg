class Source < ApplicationRecord
  include CityUrlFindable

  validates :homepage_url, presence: true, uniqueness: true
end
