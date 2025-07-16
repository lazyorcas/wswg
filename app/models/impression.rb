class Impression < ApplicationRecord
  belongs_to :impressionable, polymorphic: true
  belongs_to :event, class_name: "::Event"

  validates :event_id, uniqueness: { scope: [ :impressionable_type, :impressionable_id ] }
end
