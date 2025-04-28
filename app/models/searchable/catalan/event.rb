class Searchable::Catalan::Event < Event
  include Event::Searchable

  searchkick \
    language: "catalan",
    index_name: "events_catalan_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false
end
