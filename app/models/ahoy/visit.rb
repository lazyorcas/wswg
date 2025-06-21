class Ahoy::Visit < ApplicationRecord
  BOUNCE_DURATION = 10

  self.table_name = "ahoy_visits"

  scope :legitimate, -> { Rails.env.production? ? where("(user_id IS NOT NULL OR duration >= ? OR referrer_host IS NOT NULL) AND referrer_host != ?", BOUNCE_DURATION, ENV["HOST_NAME"]) : all }
  scope :non_admin, -> { where("user_id IS NULL OR user_id != 1") }

  # belongs_to :city, primary_key: "name", foreign_key: "city"
  belongs_to :visitor, primary_key: "visitor_token", foreign_key: "visitor_token"
  belongs_to :user, optional: true

  has_many :events, class_name: "Ahoy::Event", dependent: :destroy

  before_validation :find_or_create_visitor

  after_create_commit :queue_update_referrer_host, if: -> { referrer.present? }
  before_update :set_duration, if: :duration_synced_at_changed?

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

  def queue_update_referrer_host
    Ahoy::Visit::UpdateReferrerHostJob.perform_later(id)
  end

  def update_referrer_host!
    uri = URI.parse(referrer)
    return if uri.host.nil?

    fragments = uri.host.split(".")
    self.referrer_host = fragments.size > 2 ? fragments[1..2].join(".") : uri.host

    save!
  end

  private

  def find_or_create_visitor
    Visitor.find_or_create_by(visitor_token: visitor_token)
  end

  def set_duration
    self.duration = (duration_synced_at - started_at).to_i
  end
end
