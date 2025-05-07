class SearchQuery < ApplicationRecord
  include Searches
  include Broadcastable

  enum :status, {
    analyzing: 0,
    completed: 1,
    failed: -1,
    searching: 2
  }, default: :analyzing

  belongs_to :user
  attribute :result, SearchQuery::Result.to_type

  validates :query, presence: true
  validates :status, presence: true
  validates :result, presence: true, if: :completed?

  after_commit :queue_query, on: :create

  def queue_query
    QueryJob.perform_later(id)
  end

  def query!
    create_searches!
    build_result
    completed!

  rescue => e
    Sentry.capture_exception(e)
    broadcast_exception(e)
    failed!
  end

  def build_result
    self.result = SearchQuery::Result.new
    result.build(searches_results)
  end

  private

  def searches_results
    @searches_results ||= searches.map(&:result)
  end
end
