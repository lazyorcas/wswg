module SearchQuery::Searches
  extend ActiveSupport::Concern

  include Buildable

  included do
    has_many :searches
  end

  def create_searches!
    build_searches
    searching!

  rescue => e
    Sentry.capture_exception(e)
    broadcast_exception(e)
    failed!
  end
end
