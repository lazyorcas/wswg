class CurrentVisit::DurationSyncController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    build_new_duration_sync
    @duration_sync.call

    head(:ok)
  end

  private

  def build_new_duration_sync
    @duration_sync = Ahoy::Visit::DurationSync.new(visit: current_visit)
  end
end
