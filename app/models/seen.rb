class Seen < ApplicationRecord
  belongs_to :user
  belongs_to :seenable, polymorphic: true

  validates :user_id, uniqueness: { scope: [ :seenable_id, :seenable_type ] }
  validates :seenable_type, inclusion: { in: %w[ Event ] }
end
