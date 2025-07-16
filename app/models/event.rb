class Event < ApplicationRecord
  include Fetchable
  include Parseable
  include Duplicable
  include Locatable
  include Temporal
  include Createable
  include HandlesSources
  include DataCompleteness

  belongs_to :city_source

  # https://stackoverflow.com/a/15649020
  has_one :city, through: :city_source, autosave: false
  has_one :source, through: :city_source, autosave: false
  delegate :time_zone, to: :city

  has_many :bookmarks, dependent: :destroy
  has_many :seens, dependent: :destroy

  validates :url, uniqueness: true
end
