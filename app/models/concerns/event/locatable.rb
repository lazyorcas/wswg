module Event::Locatable
  extend ActiveSupport::Concern

  included do
    belongs_to :location, optional: true
    scope :located, -> { where.not(location_id: nil) }
  end

  def locate!
    locate
    save!
  end

  def locate
    return if location_query.blank?

    # cost efficient
    self.location = self.class.located
      .where(location_query: location_query)
      .excluding(self)
      .order(created_at: :desc)
      .first&.location

    self.location ||= Location.find_or_create_by_query(location_query, city_id: city_id)
  end
end
