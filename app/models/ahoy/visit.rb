class Ahoy::Visit < ApplicationRecord
  scope :non_user, -> { where(user_id: nil) }

  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event", dependent: :destroy
  belongs_to :user, optional: true
end
