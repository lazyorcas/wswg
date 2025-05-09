module Event::Createable
  extend ActiveSupport::Concern

  class_methods do
    def build_create_event_jobs(events_attributes, city_source_id:)
      event_urls = events_attributes.map { |event_attributes| event_attributes[:url] }.compact

      createable_urls = extract_createable_urls_from_urls(event_urls)

      createable_events_attributes = events_attributes.select do |event_attributes|
        createable_urls.include?(event_attributes[:url])
      end

      createable_events_attributes.map do |event_attributes|
        Event::CreateJob.new(city_source_id: city_source_id, **event_attributes)
      end
    end

    def extract_createable_urls_from_urls(urls)
      existing_event_urls = Event.where(url: urls).pluck(:url)
      existing_archived_urls = ArchivedLink.where(url: urls).pluck(:url)

      existing_urls = existing_event_urls + existing_archived_urls
      urls - existing_urls
    end
  end
end
