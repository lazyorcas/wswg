class Searchable::EnglishEvent < Event
  include Event::Searchable

  searchkick(
    language: "english",
    index_name: "events_english_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false
  )
end
