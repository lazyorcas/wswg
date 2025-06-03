class Seen < ApplicationRecord
  belongs_to :seenable, polymorphic: true, optional: true
  belongs_to :event, class_name: "::Event", touch: true

  validates :event_id, uniqueness: { scope: [ :seenable_type, :seenable_id ] }, if: -> { seenable.present? }
end
