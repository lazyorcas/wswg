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

  has_many :bookmarks
  has_many :seens

  validates :url, uniqueness: true

  def ongoing?
    end_date >= city.time_zone.current_date.to_s
  end

  def has_started?
    "#{start_date} #{start_time}" <= "#{city.time_zone.current_date} #{city.time_zone.current_time}"
  end
end
