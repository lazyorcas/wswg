class InterestSet < ApplicationRecord
  belongs_to :interestable, polymorphic: true

  validates :interestable_id, uniqueness: { scope: :interestable_type }
end
