class Searchable::English::Event < Event
  include Event::Searchable

  searchkick \
    index_name: "events_#{Rails.env}",
    searchable: Event::Searchable::SEARCHABLE_FIELDS,
    filterable: Event::Searchable::FILTERABLE_FIELDS,
    callbacks: false
end
