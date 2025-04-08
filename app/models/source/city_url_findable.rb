module Source::CityUrlFindable
  extend ActiveSupport::Concern

  included do
    validates :city_url_finder_class_name,
      presence: true,
      inclusion: { in: Source::City::UrlFinder::ALL.map(&:name) }

    validates :city_events_finder_class_name,
      presence: true,
      inclusion: { in: CitySource::EventsFinder::ALL.map(&:name) }
  end

  def find_city_url(city_id)
    city_url_finder = city_url_finder_class.new
    city_url_finder.find_url(source_id: id, city_id: city_id)
  end

  def find_and_create_city_source!(city_id)
    city_source = CitySource.find_or_initialize_by(
      source_id: id,
      city_id: city_id
    )

    if city_source.new_record?
      url = find_city_url(city_id)
      city_source.url = url
      city_source.save!
    end

    city_source
  end

  private

  def city_url_finder_class
    city_url_finder_class_name.constantize
  end
end
