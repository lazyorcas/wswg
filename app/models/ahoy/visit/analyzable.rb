module Ahoy::Visit::Analyzable
  extend ActiveSupport::Concern

  included do
    before_validation -> { self.analyzable = true }, if: -> { !analyzable? && should_be_analyzed? }
  end

  def should_be_analyzed?
    (user_id.present? || !bounced?) && user_id != 1 && valid_referrer_host?
  end

  private

  def bounced?
    duration.nil? || duration == 0 if started_at >= "2025-06-19T00:00:00Z"
  end

  def valid_referrer_host?
    referrer_host.nil? || referrer_host != ENV["HOST_NAME"]
  end
end
