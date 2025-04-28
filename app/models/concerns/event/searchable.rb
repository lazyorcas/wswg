module Event::Searchable
  extend ActiveSupport::Concern

  SEARCHABLE_FIELDS = [ "title^3", :description ]
  FILTERABLE_FIELDS = [ :start_date, :end_date, :start_time, :end_time, :price ]

  included do
    scope :search_import, -> { includes(:location, city: :time_zone) }
  end

  def search_data
    {
      title: title,
      description: description,
      start_date: start_date,
      end_date: end_date,
      start_time: start_time,
      end_time: end_time,
      price: price,
      location: location&.coordinates_h || city.coordinates_h
    }
  end

  def should_index?
    today = Time.current.in_time_zone(city.time_zone.name).to_date
    end_date >= today.to_s
  end
end
