class Language < ApplicationRecord
  has_many :city_languages
  has_many :cities, through: :city_languages
end
