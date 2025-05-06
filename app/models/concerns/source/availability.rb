module Source::Availability
  extend ActiveSupport::Concern

  def enable!
    city_sources.update_all(enabled: true)
  end

  def disable!
    city_sources.update_all(enabled: false)
  end
end
