class User < ApplicationRecord
  include Credits

  passwordless_with :email
  attr_accessor :terms_of_service_and_privacy_policy_accepted

  belongs_to :city

  has_one :account, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_events, through: :bookmarks, source: :event
  has_many :seens, dependent: :destroy
  has_many :seen_events, through: :seens, source: :event
  has_many :search_queries, dependent: :destroy

  has_many :visits, class_name: "Ahoy::Visit", dependent: :nullify

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :terms_of_service_and_privacy_policy_accepted, acceptance: true, if: :new_record?

  accepts_nested_attributes_for :bookmarks, :search_queries

  def email=(value)
    super(value.split("+").first)
  end
end
