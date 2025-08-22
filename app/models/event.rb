class Event < ApplicationRecord
  include Fetchable
  include Parseable
  include Duplicable
  include Organizable
  include Locatable
  include Temporal
  include Createable
  include HandlesSources
  include DataCompleteness
  include Finalizable

  belongs_to :city_source

  # https://stackoverflow.com/a/15649020
  has_one :city, through: :city_source, autosave: false
  has_one :source, through: :city_source, autosave: false
  delegate :time_zone, to: :city

  has_many :impressions, dependent: :destroy
  has_many :seens, dependent: :destroy
  has_many :recommendations

  validates :url, uniqueness: true
end
