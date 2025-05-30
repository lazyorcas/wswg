class Seen < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event, class_name: "::Event", touch: true

  validates :event_id, uniqueness: { scope: :user_id }, if: -> { user.present? }
end
