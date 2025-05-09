module User::Credits
  extend ActiveSupport::Concern

  DEFAULT_CREDITS = 2
  MONTHLY_FREE_CREDITS = 2

  included do
    has_many :credit_transactions

    validates :credits, presence: true

    after_initialize :set_default_credits
  end

  def has_credits?
    credits.positive? || admin?
  end

  def has_ongoing_usage_credit_transaction?
    credit_transactions.usage.ongoing.exists?
  end

  def has_free_credits_for_this_month?
    current_date = city.time_zone.current_date

    credit_transactions.free_top_up.where(created_at: current_date.beginning_of_month..current_date.end_of_month).exists?
  end

  def add_paid_credits!(amount)
    return if admin?

    credit_transactions.create!(
      transaction_type: :paid_top_up,
      amount: amount
    )
  end

  def add_free_credits!
    return if admin?
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
    return if admin?
    return unless must_use_credit?

    credit_transactions.create!(transaction_type: :usage)
  end

  private

  def set_default_credits
    self.credits ||= DEFAULT_CREDITS
  end
end
