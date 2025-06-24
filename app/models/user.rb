class User < ApplicationRecord
  include Credits
  include Anonymity

  passwordless_with :email

  enum :notification_frequency, {
    daily: 0,
    weekly: 1,
    monthly: 2
  }

  has_settings :personalization

  belongs_to :city, optional: true

  has_one :account, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_events, through: :bookmarks, source: :event
  has_many :seens, as: :seenable, dependent: :destroy
  has_many :seen_events, through: :seens, source: :event
  has_many :search_queries, as: :searcher, dependent: :destroy

  has_many :visits, class_name: "Ahoy::Visit", dependent: :nullify

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def email=(value)
    super(value.split("+").first)
  end
end
