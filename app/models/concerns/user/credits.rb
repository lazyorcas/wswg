module User::Credits
  extend ActiveSupport::Concern

  included do
    has_many :credit_transactions

    validates :credits, presence: true
  end

  def has_credits?
    credits.positive? || admin?
  end

  def has_ongoing_usage_credit_transaction?
    credit_transactions.usage.ongoing.exists?
  end

  def can_use_credits?
    has_credits? || has_ongoing_usage_credit_transaction?
  end

  def must_use_credit?
    has_credits? && !has_ongoing_usage_credit_transaction?
  end

  def add_credits!(amount, transaction_type:)
    return if admin?

    credit_transactions.create!(
      transaction_type: transaction_type,
      amount: amount
    )
  end

  def use_credit!
    return nil if admin?
    return nil unless must_use_credit?

    credit_transactions.create!(transaction_type: :usage)
  end
end
