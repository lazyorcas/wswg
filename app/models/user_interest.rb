class InterestSet < ApplicationRecord
  belongs_to :interestable, polymorphic: true

  def readonly?
    true
  end
end
