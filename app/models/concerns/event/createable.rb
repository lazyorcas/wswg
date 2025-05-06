module Event::Createable
  extend ActiveSupport::Concern

  class_methods do
    def extract_createable_urls_from_urls(urls)
      existing_event_urls = Event.where(url: urls).pluck(:url)
      existing_archived_urls = ArchivedLink.where(url: urls).pluck(:url)

      existing_urls = existing_event_urls + existing_archived_urls
      urls - existing_urls
    end
  end
end
