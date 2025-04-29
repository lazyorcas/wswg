class User < ApplicationRecord
  belongs_to :city

  has_one :account
  has_many :bookmarks
  has_many :seens

  has_many :visits, class_name: "Ahoy::Visit"

  has_many :bookmarked_events, through: :bookmarks, source: :event
  has_many :seen_events, through: :seens, source: :event

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
