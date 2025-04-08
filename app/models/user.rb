class User < ApplicationRecord
  belongs_to :city

  has_one :account

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def require_authentication?
    account.present? && account.token_expired?
  end
end
