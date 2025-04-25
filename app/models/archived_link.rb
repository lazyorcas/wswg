class ArchivedLink < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :reason, presence: true

  enum :reason, {
    not_found_or_expired: 0
  }
end
