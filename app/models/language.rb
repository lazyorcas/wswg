class Language < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  has_many :city_languages
  has_many :cities, through: :city_languages, source: :city
  has_many :events, through: :cities

  accepts_nested_attributes_for :city_languages
end
