class Searchable::Spanish::Event < Event
  include Event::Searchable

  searchkick \
    language: "spanish",
    index_name: "events_spanish_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    locations: [ :location ],
    callbacks: false
end
