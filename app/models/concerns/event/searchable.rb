module Event::Searchable
  extend ActiveSupport::Concern

  SEARCHABLE_FIELDS = [ "title^3", :description ]
  FILTERABLE_FIELDS = [ :start_date, :end_date, :start_time, :end_time, :price, :city_id ]

  included do
    scope :search_import, -> { includes(:city) }
  end

  def should_index?
    today = Time.current.in_time_zone(city.time_zone.name).to_date
    end_date >= today.to_s
  end
end
