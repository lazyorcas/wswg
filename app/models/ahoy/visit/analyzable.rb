module Ahoy::Visit::Analyzable
  extend ActiveSupport::Concern

  included do
    before_validation -> { self.analyzable = true }, if: -> { !analyzable? && should_be_analyzed? }
  end

  def should_be_analyzed?
    (user_id.present? || (!bounced? && valid_referrer_host?)) && !admin? && !business_owner?
  end

  private

  def bounced?
    duration.nil? || duration == 0
  end

  def valid_referrer_host?
    referrer_host.nil? || referrer_host != ENV["HOST_NAME"]
  end

  def admin?
    user_id == 1
  end
end
