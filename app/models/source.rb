class Source < ApplicationRecord
  include Scrapeable

  has_many :city_sources
  has_many :events, through: :city_sources

  validates :name, presence: true, uniqueness: true
  validates :template_url, presence: true

  def proxy?
    Rails.env.production? ? proxy : false
  end
end
