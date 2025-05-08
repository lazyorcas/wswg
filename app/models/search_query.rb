class SearchQuery < ApplicationRecord
  include SearchesBuildable
  include Broadcastable

  enum :status, {
    analyzing: 0,
    completed: 1,
    failed: -1,
    searching: 2
  }, default: :analyzing

  belongs_to :user
  has_many :searches

  attribute :result, SearchQuery::Result.to_type

  validates :query, presence: true
  validates :status, presence: true
  validates :result, presence: true, if: :completed?

  after_commit :queue_query, on: :create

  def queue_query
    QueryJob.perform_later(id)
  end

  def query!
    build_searches
    queue_poll_for_searches_results
    searching!

  rescue => e
    Sentry.capture_exception(e)
    broadcast_exception(e)
    failed!
  end

  def complete?
    searches.all?(&:completed?)
  end

  def complete!
    build_result
    completed!

  rescue => e
    Sentry.capture_exception(e)
    broadcast_exception(e)
    failed!
  end

  def build_result
    self.result = SearchQuery::Result.new
    result.build(completed_searches_results)
  end

  private

  def completed_searches_results
    searches.completed.map(&:result)
  end

  def queue_poll_for_searches_results
    PollForSearchesResultsJob.perform_later(id)
  end
end
