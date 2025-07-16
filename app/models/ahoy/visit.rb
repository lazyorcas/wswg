class Ahoy::Visit < ApplicationRecord
  include Analyzable

  BOUNCE_DURATION = 10

  self.table_name = "ahoy_visits"

  # belongs_to :city, primary_key: "name", foreign_key: "city"
  belongs_to :visitor, primary_key: "visitor_token", foreign_key: "visitor_token"
  belongs_to :user, optional: true

  has_many :events, class_name: "Ahoy::Event", dependent: :destroy

  before_validation :find_or_create_visitor

  after_create_commit :queue_update_referrer_host
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
    if landing_page.include?("gad_source")
      self.referrer_host = "google_ads"
      save and return
    end

    if utm_source.present? && utm_source.include?("chatgpt.com")
      self.referrer_host = "chatgpt"
      save and return
    end

    if utm_medium.present? && utm_medium.include?("email")
      self.referrer_host = "email"
      save and return
    end

    return if referrer.blank?

    uri = URI.parse(referrer)
    return if uri.host.nil?

    fragments = uri.host.split(".")
    self.referrer_host = if fragments.include?("google")
      "google"
    elsif fragments.include?("linkedin")
      "linkedin"
    elsif fragments.include?("reddit")
      "reddit"
    elsif fragments.include?("chatgpt.com")
      "chatgpt"
    elsif fragments.size > 2
      fragments[1..2].join(".")
    else
      uri.host
    end

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
