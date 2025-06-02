class CreditTransaction < ApplicationRecord
  USAGE_AMOUNT = -1
  USAGE_EXPIRATION_TIME = 24.hours

  scope :ongoing, -> { where("expires_at > ?", Time.current) }

  belongs_to :creditable, polymorphic: true

  enum :transaction_type, {
    usage: -1,
    free_top_up: 0,
    paid_top_up: 1,
    admin_top_up: 2
  }

  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: { other_than: 0 }

  with_options if: :usage? do
    validates :expires_at, presence: true
    validates :creditable_id, uniqueness: {
      scope: [ :creditable_type, :transaction_type ],
      conditions: -> { ongoing },
      message: "already has an ongoing usage transaction"
    }

    before_validation { self.amount ||= USAGE_AMOUNT }
    before_validation { self.expires_at ||= USAGE_EXPIRATION_TIME.from_now }
  end

  after_create :update_credits!

  private

  def update_credits!
    creditable.credits += amount
    creditable.save!
  end
end
