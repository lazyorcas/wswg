module Event::Createable
  extend ActiveSupport::Concern

  class << self
    def get_createable_event_urls(event_urls)
      # TODO: Luma urls are not unique
      existing_event_urls = Event.where(url: event_urls).pluck(:url)
      existing_archived_urls = ArchivedLink.where(url: event_urls).pluck(:url)

      existing_urls = existing_event_urls + existing_archived_urls
      event_urls - existing_urls
    end
  end
end
