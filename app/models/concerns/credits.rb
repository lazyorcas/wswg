module Credits
  extend ActiveSupport::Concern

  DEFAULT_CREDITS = 5
  MONTHLY_FREE_CREDITS = 5

  included do
    has_many :credit_transactions, as: :creditable, dependent: :destroy

    validates :credits, presence: true

    before_create :set_default_credits, if: -> { credits.zero? }
  end

  def has_credits?
    credits.positive?
  end

  def has_ongoing_usage_credit_transaction?
    credit_transactions.usage.ongoing.exists?
  end

  def has_free_credits_for_this_month?
    current_date = city.time_zone.current_date
    credit_transactions.free_top_up.where(created_at: current_date.beginning_of_month.beginning_of_day..current_date.end_of_month.end_of_day).exists?
  end

  def add_credits!(amount, transaction_type)
    credit_transactions.create!(
      transaction_type: transaction_type,
      amount: amount
    )
  end

  def add_free_credits!
    return if has_free_credits_for_this_month?
    credit_transactions.create!(
      transaction_type: :free_top_up,
      amount: MONTHLY_FREE_CREDITS
    )
  end

  def can_use_credits?
    has_credits? || has_ongoing_usage_credit_transaction?
  end

  def must_use_credit?
    has_credits? && !has_ongoing_usage_credit_transaction?
  end

  def use_credit!
    return unless must_use_credit?
    credit_transactions.create!(transaction_type: :usage)
  end

  private

  def set_default_credits
    self.credits = DEFAULT_CREDITS
  end
end
