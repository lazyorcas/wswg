class Searchable::Catalan::Event < Event
  searchkick \
    language: "catalan",
    index_name: "events_catalan_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    callbacks: false
end
