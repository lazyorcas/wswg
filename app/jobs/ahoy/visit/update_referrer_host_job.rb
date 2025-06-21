class Ahoy::Visit::UpdateReferrerHostJob < ApplicationJob
  queue_as :default

  def perform(visit_id)
    visit = Ahoy::Visit.find(visit_id)
    visit.update_referrer_host!
  end
end
