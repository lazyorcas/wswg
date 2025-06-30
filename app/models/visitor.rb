class Visitor < ApplicationRecord
  include IsPerson
  include Credits

  has_many :seens, as: :seenable, dependent: :destroy
  has_many :seen_events, through: :seens, source: :event
  has_many :search_queries, as: :searcher, dependent: :destroy

  has_many :visits, class_name: "Ahoy::Visit", primary_key: "visitor_token", foreign_key: "visitor_token", dependent: :destroy
  has_many :field_test_memberships, class_name: "FieldTest::Membership", as: :participant, dependent: :nullify

  validates :visitor_token, presence: true, uniqueness: true
end
