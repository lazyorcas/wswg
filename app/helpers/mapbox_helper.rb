module MapboxHelper
  def get_mapbox_coordinates(coordinates)
    [ coordinates[:lon], coordinates[:lat] ]
  end
end
