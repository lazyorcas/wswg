class Search < ApplicationRecord
  enum :status, {
    searching: 0,
    completed: 1,
    failed: -1
  }, default: :searching

  belongs_to :search_query
  attribute :result, Search::Result.to_type

  validates :keywords, presence: true
  validates :conditions, presence: true
  validates :status, presence: true
  validates :model_type, presence: true, inclusion: { in: %w[ Event ] }
  validates :searchable_model_type, presence: true
  validates :result, presence: true, if: :completed?

  after_commit :queue_query, on: :create

  def model
    @model ||= model_type.constantize
  end

  def searchable_model
    @searchable_model ||= searchable_model_type.constantize
  end

  def query!
    self.result = Search::Result.new

    searchkick_result = searchable_model.search(
      self.keywords,
      where: self.conditions.deep_symbolize_keys,
      load: false
    )

    self.result.hits = searchkick_result.response["hits"]["hits"].map do |hit|
      {
        id: hit["_id"],
        score: hit["_score"]
      }
    end
    self.result.took = searchkick_result.took
    self.result.count = searchkick_result.total_count

    self.status = :completed
    save!
  rescue => e
    Sentry.capture_exception(e)

    self.result.error = e.message
    self.status = :failed
    save!
  end

  def queue_query
    QueryJob.perform_later(id)
  end
end
