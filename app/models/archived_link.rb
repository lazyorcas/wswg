class ArchivedLink < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :reason, presence: true

  enum :reason, {
    not_found_or_expired: 0,
    duplicated: 1,
    data_incomplete: 2,
    other: -1
  }
end
