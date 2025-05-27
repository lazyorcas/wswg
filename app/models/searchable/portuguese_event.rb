class Searchable::PortugueseEvent < Event
  include Event::Searchable

  searchkick(
    language: "portuguese",
    index_name: "events_portuguese_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false,
    search_synonyms: YAML.load_file("config/synonyms/portuguese_synonyms.yml")
  )

  def language
    Language.find_by(code: "pt")
  end
end
