class Searchable::EnglishEvent < Event
  include Event::Searchable

  def self.synonyms
    @synonyms ||= YAML.load_file("config/synonyms/english_synonyms.yml")
  end

  searchkick(
    language: "english",
    index_name: "events_english_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false,
    search_synonyms: synonyms
  )

  def language
    Language.find_by(code: "en")
  end
end
