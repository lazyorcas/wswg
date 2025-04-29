module Event::Createable
  extend ActiveSupport::Concern

  class << self
    def get_createable_urls(urls)
      # TODO: Luma urls are not unique
      existing_event_urls = Event.where(url: urls).pluck(:url)
      existing_archived_urls = ArchivedLink.where(url: urls).pluck(:url)

      existing_urls = existing_event_urls + existing_archived_urls
      urls - existing_urls
    end
  end
end
