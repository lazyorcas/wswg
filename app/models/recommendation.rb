class Recommendation < ApplicationRecord
  belongs_to :recommendable, polymorphic: true
  belongs_to :event, class_name: "::Event"

  def readonly?
    true
  end
end
