class AddUrlParamsToCitySources < ActiveRecord::Migration[8.0]
  def change
    add_column :city_sources, :url_params, :jsonb, default: {}
  end
end

# CitySource.includes(:source).find_each do |city_source|
#   city_slug = nil

#   if city_source.source.name == "Eventbrite"
#     city_slug = city_source.url.match(/https:\/\/www\.eventbrite\.com\/d\/(.*)\/all-events\//)[1]

#   elsif city_source.source.name == "Luma"
#     city_slug = city_source.url.match(/https:\/\/lu\.ma\/(.*)/)[1]

#   elsif city_source.source.name == "Meetup"
#     city_slug = city_source.url.match(/https:\/\/www\.meetup\.com\/find\/\?location=(.*)&eventType=inPerson&source=EVENTS&sortField=DATETIME/)[1]
#   end

#   if city_slug.present?
#     city_source.update!(url_params: { city_slug: city_slug })
#   end
# end
