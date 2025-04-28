class TimeZone < ApplicationRecord
  validates :name,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:tzinfo).map(&:name) }
end
