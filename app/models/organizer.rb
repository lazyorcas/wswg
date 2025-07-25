class Organizer < ApplicationRecord
  belongs_to :source
  has_many :events
  has_many :event_locations, through: :events, source: :location

  validates_presence_of :name, if: -> { url.blank? }
  validates_presence_of :url, if: -> { name.blank? }
  validates_uniqueness_of :url, scope: :source_id
end
