class CreditTransaction < ApplicationRecord
  USAGE_EXPIRATION_TIME = 24.hours
  USAGE_AMOUNT = -1

  scope :ongoing, -> { where("expires_at > ?", Time.current) }

  belongs_to :user

  enum :transaction_type, {
    usage: -1,
    free_top_up: 0,
    paid_top_up: 1
  }

  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: { other_than: 0 }
  validates :expires_at, presence: true, if: :usage?
  validate :validate_user_does_not_have_ongoing_usage_transaction, if: :usage?

  before_validation :set_amount
  before_validation :set_expires_at
  after_create :update_user_balance!

  def user_has_ongoing_usage_transaction?
    user.has_ongoing_usage_credit_transaction?
  end

  private

  def set_amount
    if usage?
      self.amount ||= USAGE_AMOUNT
    end
  end

  def set_expires_at
    if usage?
      self.expires_at ||= USAGE_EXPIRATION_TIME.from_now
    end
  end

  def update_user_balance!
    user.credits += amount
    user.save!
  end

  def validate_user_does_not_have_ongoing_usage_transaction
    return unless user_has_ongoing_usage_transaction?
    errors.add(:base, "User already has an ongoing usage transaction")
  end
end
