class Bookmark < ApplicationRecord
  belongs_to :bookmarker, polymorphic: true
  belongs_to :bookmarkable, polymorphic: true

  validates :bookmarkable_id, uniqueness: { scope: [ :bookmarkable_type, :bookmarker_id, :bookmarker_type ] }
end
