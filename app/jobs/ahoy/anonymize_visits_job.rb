class Ahoy::AnonymizeVisitsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Ahoy::Visit
      .where.associated(:user)
      .where(started_at: 2.hours.ago..)
      .find_each do |visit|
        masked_ip = Ahoy.mask_ip(visit.ip)
        visit.update_column :ip, masked_ip
        visit.update_column :latitude, nil
        visit.update_column :longitude, nil
    end
  end
end
