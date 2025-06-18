class Ahoy::Visit::DurationSync
  include ActiveModel::Model

  attr_accessor :visit

  def call
    visit.update(duration_synced_at: Time.current)
  end
end
