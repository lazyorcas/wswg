class Searchable::EventByKeywords < Event
  def self.synonyms
    @synonyms ||= YAML.load_file("config/synonyms/english_synonyms.yml")
  end

  searchkick(
    language: "english",
    index_name: "events_by_keywords_english_#{Rails.env}",
    searchable: [ :title, :description, :tags ],
    callbacks: false,
    search_synonyms: synonyms
  )
end
