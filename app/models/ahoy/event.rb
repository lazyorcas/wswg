class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  scope :legitimate, -> { joins(:visit).where("ahoy_visits.referrer IS NULL OR ahoy_visits.landing_page IS NULL OR ahoy_visits.referrer != ahoy_visits.landing_page") }
  scope :visitors, -> { where.missing(:user).legitimate }

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true
end
