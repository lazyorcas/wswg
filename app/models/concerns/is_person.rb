module IsPerson
  extend ActiveSupport::Concern

  include Person::Preferences
  include Person::Recommendations

  included do
    belongs_to :city, optional: true

    has_many :impressions, as: :impressionable, dependent: :destroy
    has_many :impression_events, through: :impressions, source: :event

    has_many :seens, as: :seenable, dependent: :destroy
    has_many :seen_events, through: :seens, source: :event

    has_many :search_queries, as: :searcher, dependent: :destroy

    has_many :field_test_memberships, class_name: "FieldTest::Membership", as: :participant, dependent: :nullify
  end
end
