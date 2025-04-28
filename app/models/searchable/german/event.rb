class Searchable::German::Event < Event
  include Event::Searchable

  searchkick \
    language: "german",
    index_name: "events_german_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false
end
