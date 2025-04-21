class DeadLink < ApplicationRecord
  validates :url, presence: true, uniqueness: true
end
