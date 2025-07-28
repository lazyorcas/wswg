class Searchable::EventByKeywords < Event
  scope :search_import, -> { includes(:city_source) }

  def self.synonyms
    @synonyms ||= YAML.load_file("config/synonyms/english_synonyms.yml")
  end

  searchkick(
    language: "english",
    index_name: "events_by_keywords_english_#{Rails.env}",
    searchable: [ :title, :description, :tags ],
    filterable: [ :dow, :start_time, :end_time, :city_id, :source_id ],
    callbacks: false,
    search_synonyms: synonyms
  )

  def search_data
    {
      title: title,
      description: description,
      tags: tags,
      dow: dow,
      start_time: start_time,
      end_time: end_time,
      city_id: city_source.city_id,
      source_id: city_source.source_id
    }
  end
end
