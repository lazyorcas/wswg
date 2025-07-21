class User < ApplicationRecord
  include IsPerson
  include Anonymity

  passwordless_with :email

  has_one :account, dependent: :destroy
  has_many :visits, class_name: "Ahoy::Visit", dependent: :nullify
  has_many :events, through: :visits, source: :event

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def email=(value)
    super(value.split("+").first)
  end

  def returning?
    true
  end
end
