class Seen < ApplicationRecord
  belongs_to :user
  belongs_to :event, class_name: "::Event"

  validates :user_id, uniqueness: { scope: :event_id }
end
