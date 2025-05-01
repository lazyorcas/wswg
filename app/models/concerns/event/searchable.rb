module Event::Searchable
  extend ActiveSupport::Concern

  SEARCHABLE_FIELDS = [ :title, :description ]
  FILTERABLE_FIELDS = [ :start_date, :end_date, :start_time, :end_time, :price ]

  included do
    scope :search_import, -> { includes(:location, city_source: :city) }
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
      location: location&.coordinates_h || city_source.city.coordinates_h
    }
  end

  def should_index?
    end_date >= city_source.city.time_zone.current_date.to_s
  end
end
