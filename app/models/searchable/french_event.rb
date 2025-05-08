class Searchable::FrenchEvent < Event
  include Event::Searchable

  searchkick(
    language: "french",
    index_name: "events_french_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false
  )

  def language
    Language.find_by(code: "fr")
  end
end
