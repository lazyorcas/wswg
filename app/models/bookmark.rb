class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :event, class_name: "::Event"

  validates :user_id, uniqueness: { scope: :event_id }
  validates :removed_at, presence: true, if: :removed?

  before_validation :set_removed_at, on: :update

  private

  def set_removed_at
    if removed?
      self.removed_at = Time.current
    else
      self.removed_at = nil
    end
  end
end
