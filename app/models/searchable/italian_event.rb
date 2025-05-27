class Searchable::ItalianEvent < Event
  include Event::Searchable

  def self.synonyms
    @synonyms ||= YAML.load_file("config/synonyms/italian_synonyms.yml")
  end

  searchkick(
    language: "italian",
    index_name: "events_italian_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false,
    search_synonyms: synonyms
  )

  def language
    Language.find_by(code: "it")
  end
end
