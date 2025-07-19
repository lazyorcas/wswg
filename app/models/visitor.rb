class Visitor < ApplicationRecord
  include IsPerson

  has_many :visits, class_name: "Ahoy::Visit", primary_key: "visitor_token", foreign_key: "visitor_token", dependent: :destroy

  validates :visitor_token, presence: true, uniqueness: true
end
