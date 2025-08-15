class Bookmark < ApplicationRecord
  belongs_to :bookmarker, polymorphic: true
  belongs_to :bookmarkable, polymorphic: true

  validates :bookmarkable_id, uniqueness: { scope: [ :bookmarkable_type, :bookmarker_id, :bookmarker_type ] }
  validates :removed_at, presence: true, if: :removed?

  before_validation :set_removed_at, on: :update, if: :removed_changed?

  private

  def set_removed_at
    if removed?
      self.removed_at = Time.current
    else
      self.removed_at = nil
    end
  end
end
