module User::Anonymity
  extend ActiveSupport::Concern

  included do
    after_create_commit :queue_anonymize_visits
  end

  def anonymize_visits!
    visits.each do |visit|
      anonymized_data = Ahoy::Visit.anonymize(
        ip: visit.ip,
        lat: visit.latitude,
        lon: visit.longitude
      )

      visit.update!(
        ip: anonymized_data[:ip],
        latitude: anonymized_data[:lat],
        longitude: anonymized_data[:lon]
      )
    end
  end

  def queue_anonymize_visits
    User::AnonymizeVisitsJob.perform_later(id)
  end
end
