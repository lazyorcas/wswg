class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  scope :visitors, -> { where.missing(:user).where("referrer != landing_page") }

  # belongs_to :city, primary_key: "name", foreign_key: "city"
  belongs_to :visitor, primary_key: "visitor_token", foreign_key: "visitor_token"
  belongs_to :user, optional: true

  has_many :events, class_name: "Ahoy::Event", dependent: :destroy

  before_validation :find_or_create_visitor

  before_update :update_duration, if: :duration_synced_at_changed?

  def self.anonymize(ip:, lat:, lon:)
    masked_ip = Ahoy.mask_ip(ip)
    noisy_lat = nil
    noisy_lon = nil

    if lat.present? && lon.present?
      noisy_coords = Geospatial.add_noise_to_coords({ lat: lat, lon: lon })
      noisy_lat = noisy_coords[:lat].round(4)
      noisy_lon = noisy_coords[:lon].round(4)
    end

    { ip: masked_ip, lat: noisy_lat, lon: noisy_lon }
  end

  def time_zone
    TimeZone.new(name: self[:time_zone])
  end

  def duration_in_mins
    duration / 60
  end

  private

  def find_or_create_visitor
    Visitor.find_or_create_by(visitor_token: visitor_token)
  end

  def update_duration
    self.duration = (duration_synced_at - started_at).to_i
  end
end
