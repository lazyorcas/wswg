module Source::Availability
  extend ActiveSupport::Concern

  def enable!
    transaction do
      city_sources.update_all(enabled: true)
      update!(enabled: true)
    end
  end

  def disable!
    transaction do
      city_sources.update_all(enabled: false)
      update!(enabled: false)
    end
  end
end
