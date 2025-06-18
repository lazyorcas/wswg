class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  scope :visitors, -> { where.missing(:user) }

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true
end
