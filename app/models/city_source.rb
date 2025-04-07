class CitySource < ApplicationRecord
  include Verifiable
  include EventsFindable

  belongs_to :city
  belongs_to :source, optional: true

  validates :url, presence: true
  validates :city_events_finder_class_name,
    presence: true,
    inclusion: { in: CitySource::EventsFinder::ALL.map(&:name) },
    if: -> { source.nil? }


  after_commit :queue_verify, on: :create, if: -> { verified.nil? }

  def city_events_finder_class_name
    (super || source.city_events_finder_class_name)
  end
end
