class Business < ApplicationRecord
  include Sluggish
  include IsPerson

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :logo_url, presence: true

  def sluggish_field
    name
  end
end
