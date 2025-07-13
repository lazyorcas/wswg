class User < ApplicationRecord
  include IsPerson
  # include Credits
  include Anonymity

  passwordless_with :email

  has_one :account, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :bookmarked_events, through: :bookmarks, source: :event
  has_many :seens, as: :seenable, dependent: :destroy
  has_many :seen_events, through: :seens, source: :event
  has_many :search_queries, as: :searcher, dependent: :destroy

  has_many :visits, class_name: "Ahoy::Visit", dependent: :nullify
  has_many :field_test_memberships, class_name: "FieldTest::Membership", as: :participant, dependent: :nullify

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def email=(value)
    super(value.split("+").first)
  end
end
