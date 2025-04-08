class CitySource < ApplicationRecord
  include Verifiable
  include EventsFindable

  belongs_to :city
  belongs_to :source, optional: true

  validates :url, presence: true

  with_options if: -> { source_id.nil? } do
    validates :city_events_finder_class_name,
      presence: true,
      inclusion: { in: CitySource::EventsFinder::ALL.map(&:name) }

    validates :icon_url, presence: true
  end

  after_commit :queue_verify, on: :create, if: -> { verified.nil? }
end
