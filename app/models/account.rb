class Account < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :auth_hash, presence: true

  def token_expired?
    token_expires_at < Time.current
  end

  def token_expires_at
    Time.at(auth_hash["credentials"]["expires_at"])
  end

  def image_url
    auth_hash["info"]["image"]
  end
end
