module Event::Searchable
  extend ActiveSupport::Concern

  included do
    searchkick \
      searchable: [ "title", "description" ],
      filterable: [ "start_date", "end_date", "start_time", "end_time", "price" ]
  end
end
