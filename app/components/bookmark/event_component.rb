class Bookmark::EventComponent < Map::EventComponent
  attr_reader :color

  def data
    data = super

    if data[:map_feature].present?
      data[:map_feature][:properties][:dow] = Date.parse(event.start_date).wday.to_s
    end

    data
  end
end
