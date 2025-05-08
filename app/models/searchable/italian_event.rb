class Searchable::ItalianEvent < Event
  include Event::Searchable

  searchkick(
    language: "italian",
    index_name: "events_italian_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false
  )

  def language
    Language.find_by(code: "it")
  end
end
