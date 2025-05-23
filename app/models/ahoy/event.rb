class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  scope :non_user, -> { where(user_id: nil) }

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true
end
