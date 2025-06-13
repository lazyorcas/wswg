module Cloudflare::Turnstile
  extend ActiveSupport::Concern

  included do
    before_action :validate_cloudflare_turnstile
    rescue_from RailsCloudflareTurnstile::Forbidden, with: :handle_cloudflare_turnstile_forbidden
  end

  private

  def handle_cloudflare_turnstile_forbidden
    head(:forbidden)
  end
end
