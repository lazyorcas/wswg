class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  scope :visitors, -> { joins(:visit).where.missing(:user).where("ahoy_visits.referrer != ahoy_visits.landing_page") }

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true
end
