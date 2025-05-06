class Seen < ApplicationRecord
  belongs_to :user
  belongs_to :event, class_name: "::Event"

  validates :event_id, uniqueness: { scope: :user_id }
end
