class Visitor < ApplicationRecord
  include IsPerson
  include Credits

  has_many :seens, as: :seenable, dependent: :destroy
  has_many :seen_events, through: :seens, source: :event
  has_many :search_queries, as: :searcher, dependent: :destroy

  has_many :visits, class_name: "Ahoy::Visit", primary_key: "visitor_token", foreign_key: "visitor_token", dependent: :destroy
  has_many :field_test_memberships, class_name: "FieldTest::Membership", as: :participant, dependent: :destroy

  validates :visitor_token, presence: true, uniqueness: true

  after_create_commit :capture_no_visits, if: -> { visits.empty? }

  private

  def capture_no_visits
    Sentry.capture_message("Visitor has no visits", level: :warning, extra: { id: id })
  end
end
