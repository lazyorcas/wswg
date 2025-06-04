class Ahoy::AnonymizeVisitsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Ahoy::Visit
      .where.associated(:user)
      .where(started_at: 2.hours.ago..)
      .find_each do |visit|
        masked_ip = Ahoy.mask_ip(visit.ip)
        location = Geocoder.search(masked_ip).first

        visit.update_column :ip, masked_ip
        visit.update_column :latitude, location.try(:latitude).presence
        visit.update_column :longitude, location.try(:longitude).presence
    end
  end
end
