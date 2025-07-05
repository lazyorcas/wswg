module Ahoy::Visit::Analyzable
  extend ActiveSupport::Concern

  included do
    before_validation -> { self.analyzable = true }, if: -> { !analyzable? && should_be_analyzed? }
  end

  def should_be_analyzed?
    (user_id.present? || !bounced?) && user_id != 1
  end

  private

  def bounced?
    duration == 0
  end
end
