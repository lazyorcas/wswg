class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  validates :user_id, uniqueness: { scope: [ :bookmarkable_id, :bookmarkable_type ] }
  validates :bookmarkable_type, inclusion: { in: %w[ Event ] }
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
