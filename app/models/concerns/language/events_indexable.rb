module Language::EventsIndexable
  extend ActiveSupport::Concern

  class_methods do
    def define_searchable_event_classes
      find_each do |language|
        language.define_searchable_event_class
      end
    end
  end

  included do
    after_commit :define_searchable_event_class, on: :create
  end

  def define_searchable_event_class
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1
      class #{searchable_event_class_name} < Event
        include Event::Searchable
        searchkick(
          language: "#{name.downcase}",
          index_name: "events_#{name.downcase}_#{Rails.env}",
          searchable: Event::Searchable::SEARCHABLE_FIELDS,
          filterable: Event::Searchable::FILTERABLE_FIELDS,
          locations: [ :location ],
          callbacks: false
        )
      end
    RUBY
  end

  private

  def searchable_event_class_name
    @searchable_event_class_name ||= "Searchable::#{name.capitalize}Event"
  end
end
