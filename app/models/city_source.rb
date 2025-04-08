class CitySource < ApplicationRecord
  include Verifiable
  include EventsFindable

  belongs_to :city
  belongs_to :source, optional: true

  validates :url, presence: true
  validates :city_events_finder_class_name,
    presence: true,
    inclusion: { in: CitySource::EventsFinder::ALL.map(&:name) }


  after_commit :queue_verify, on: :create, if: -> { verified.nil? }

  private

  def validate_city_events_finder_class_name
    if source.present? && city_events_finder_class_name != source.city_events_finder_class_name
      errors.add(:city_events_finder_class_name, "must be the same as the source's city_events_finder_class_name")
    end
  end
end
