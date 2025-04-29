# TODO: add non null check to city_sources

class CreateSources < ActiveRecord::Migration[8.0]
  def change
    create_table :sources do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :template_url, null: false
      t.boolean :proxy, null: false, default: false

      t.timestamps
    end

    add_reference :city_sources, :source, index: true, foreign_key: true
  end
end

# Source.create!(name: "Eventbrite", template_url: "https://www.eventbrite.com/d/%{city_slug}/all-events/", proxy: true)
# Source.create!(name: "Luma", template_url: "https://lu.ma/%{city_slug}", proxy: false)
# Source.create!(name: "Meetup", template_url: "https://www.meetup.com/find/?location=%{city_slug}&eventType=inPerson&source=EVENTS&sortField=DATETIME", proxy: false)
# Source.create!(name: "MuenchenDe", template_url: "https://www.muenchen.de/en/events", proxy: false)

# CitySource.find_each do |city_source|
#   city_source.update!(source: Source.find_by!(name: city_source.name))
# end
