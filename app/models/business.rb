class Business < ApplicationRecord
  include Sluggish

  belongs_to :city

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :logo_url, presence: true

  def sluggish_field
    name
  end
end
