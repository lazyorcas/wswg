class Account < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :auth_hash, presence: true

  def provider_strategy_class
    "OmniAuth::Strategies::#{provider.classify}".constantize
  end

  def provider_strategy
    @provider_strategy ||= begin
      strategy = provider_strategy_class.new(nil)
      strategy.options.client_id = ENV["#{provider.upcase}_CLIENT_ID"]
      strategy.options.client_secret = ENV["#{provider.upcase}_CLIENT_SECRET"]
      strategy
    end
  end

  def token_expired?
    token_expires_at < Time.current
  end

  def token_expires_at
    Time.at(auth_hash.dig("credentials", "expires_at"))
  end

  def refresh_token!
    return unless token_expired?

    access_token = OAuth2::AccessToken.new(
      provider_strategy.client,
      auth_hash.dig("credentials", "token"),
      refresh_token: auth_hash.dig("credentials", "refresh_token")
    )

    new_token = access_token.refresh!

    auth_hash["credentials"]["token"] = new_token.token
    auth_hash["credentials"]["expires_at"] = new_token.expires_at
    save!
  end

  def image_url
    auth_hash.dig("info", "image")
  end
end
