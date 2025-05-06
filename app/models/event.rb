class Event < ApplicationRecord
  include Fetchable
  include Parseable
  include Duplicable
  include Locatable
  include Dateful
  include Createable
  include HandlesSources
  include DataCompleteness

  belongs_to :city_source

  # https://stackoverflow.com/a/15649020
  has_one :city, through: :city_source, autosave: false
  has_one :source, through: :city_source, autosave: false
  delegate :time_zone, to: :city

  has_many :bookmarks
  has_many :bookmark_users, through: :bookmarks, source: :user
  has_many :seens
  has_many :seen_users, through: :seens, source: :user

  validates :url, uniqueness: true

  def ongoing?
    end_date >= current_date_in_city.to_s
  end

  private

  def current_date_in_city
    city.time_zone.current_date
  end
end
