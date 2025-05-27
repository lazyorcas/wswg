class Searchable::FrenchEvent < Event
  include Event::Searchable

  def self.synonyms
    @synonyms ||= YAML.load_file("config/synonyms/french_synonyms.yml")
  end

  searchkick(
    language: "french",
    index_name: "events_french_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false,
    search_synonyms: synonyms
  )

  def language
    Language.find_by(code: "fr")
  end
end
