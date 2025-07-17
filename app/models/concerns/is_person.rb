module IsPerson
  extend ActiveSupport::Concern

  include Person::Preferences

  included do
    belongs_to :city, optional: true

    has_many :impressions, as: :impressionable, dependent: :destroy
    has_many :impression_events, through: :impressions, source: :event

    has_many :seens, as: :seenable, dependent: :destroy
    has_many :seen_events, through: :seens, source: :event

    has_many :bookmarks, as: :bookmarkable, dependent: :destroy
    has_many :bookmarked_events, through: :bookmarks, source: :event

    has_many :search_queries, as: :searcher, dependent: :destroy

    has_many :field_test_memberships, class_name: "FieldTest::Membership", as: :participant, dependent: :nullify

    has_one :interest_set, as: :interestable
    has_many :recommendations, as: :recommendable
    has_many :recommended_events, through: :recommendations, source: :event

    has_many :materialized_recommendations, as: :recommendable
    has_many :materialized_recommended_events, through: :materialized_recommendations, source: :event
  end
end
