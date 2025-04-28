module Event::Fetchable::PreciseLocationQuery
  extend ActiveSupport::Concern

  LOCATION_IS_CITY_QUESTION = "Is the location a city?".freeze

  def location_query=(query)
    if precise_location?(query)
      @location_query = query

    elsif missing_city_name?(query)
      @location_query = "#{query}, #{source.city.name}"
    end
  end

  private

  def precise_location?(query)
    !location_is_city?(query)
  end

  def location_is_city?(query)
    geographer.true_or_false?(
      location: query,
      question: LOCATION_IS_CITY_QUESTION
    )
  end

  def missing_city_name?(query)
    !has_city_name?(query)
  end

  def has_city_name?(query)
    source.city.contains?(query)
  end

  def geographer
    @geographer ||= OpenAI::Assistants::Geographer.new
  end
end
