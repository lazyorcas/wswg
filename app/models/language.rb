class Language < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  has_many :city_languages

  accepts_nested_attributes_for :city_languages
end
