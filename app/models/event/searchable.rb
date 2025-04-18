module Event::Searchable
  extend ActiveSupport::Concern

  included do
    searchkick \
      searchable: [ "title^3", :description ],
      filterable: [ :start_date, :end_date, :start_time, :end_time, :price, :city_id ],
      # https://github.com/ankane/searchkick?tab=readme-ov-file#strategies
      callbacks: false

    scope :search_import, -> { includes(:city) }
  end

  # https://github.com/ankane/searchkick?tab=readme-ov-file#indexing
  def should_index?
    today = Time.current.in_time_zone(city.time_zone).to_date
    end_date >= today.to_s
  end
end
