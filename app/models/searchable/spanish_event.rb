class Searchable::SpanishEvent < Event
  include Event::Searchable

  searchkick(
    language: "spanish",
    index_name: "events_spanish_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false,
    search_synonyms: YAML.load_file("config/synonyms/spanish_synonyms.yml")
  )

  def language
    Language.find_by(code: "es")
  end
end
