class Organizer < ApplicationRecord
  belongs_to :source
  has_many :events

  validates_presence_of :name, if: -> { url.blank? }
  validates_presence_of :url, if: -> { name.blank? }
  validates_uniqueness_of :name, scope: [ :source_id, :url ]
end
