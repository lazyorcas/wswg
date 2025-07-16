module Event::Searchable
  extend ActiveSupport::Concern

  SEARCHABLE_FIELDS = [ :title, :description, :tags ]
  FILTERABLE_FIELDS = [ :start_date, :end_date, :start_time, :end_time, :price ]

  included do
    scope :search_import, -> { includes(:location, city: :languages) }
  end

  def search_data
    {
      title: title,
      description: description,
      tags: tags,
      start_date: start_date,
      end_date: end_date,
      start_time: start_time,
      end_time: end_time,
      price: price,
      location: location&.coordinates || city.coordinates
    }
  end

  def should_index?
    data_completed? && !has_ended? && city.languages.include?(language)
  end

  def language
    raise NotImplementedError
  end
end
