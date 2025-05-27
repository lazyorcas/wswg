class Searchable::DutchEvent < Event
  include Event::Searchable

  searchkick(
    language: "dutch",
    index_name: "events_dutch_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false,
    search_synonyms: YAML.load_file("config/synonyms/dutch_synonyms.yml")
  )

  def language
    Language.find_by(code: "nl")
  end
end
