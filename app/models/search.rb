class Search < ApplicationRecord
  include Broadcastable

  enum :status, {
    processing: 0,
    completed: 1,
    failed: -1
  }, default: :processing

  belongs_to :user

  attribute :result, Search::Result.to_type

  validates :query, presence: true
  validates :status, presence: true
  validates :model_type, presence: true, inclusion: { in: %w[ Event ] }

  with_options if: :completed? do
    validates :keywords, presence: true
    validates :conditions, presence: true
    validates :result, presence: true
  end

  after_commit :queue_query, on: :create
  after_commit :broadcast_completed, on: :update, if: -> { status_previously_changed?(to: :completed) }

  def model
    model_type.constantize
  end

  def queue_query
    QueryJob.perform_later(id)
  end

  def query!
    self.result = Search::Result.new

    begin
      query_object = build_query_object

      keywords = build_keywords(query_object)
      keywords << "*" if keywords.empty?
      self.keywords = keywords.join(" ")

      self.conditions = build_conditions(query_object)

      result = model.search(
        self.keywords,
        where: self.conditions.deep_symbolize_keys,
        load: false
      )

      self.result.hits = result.response["hits"]["hits"].map do |hit|
        {
          id: hit["_id"],
          score: hit["_score"]
        }
      end
      self.result.took = result.took
      self.result.count = result.total_count

      self.status = :completed
    rescue => e
      self.result.error = e.message
      self.status = :failed

      if e.is_a?(UserReadableError)
        broadcast_error(e.message)
      else
        broadcast_error("Failed to search. Try again.")
      end

      broadcast_update_to(self, target: "search-results", html: "")
    end

    save!
  end

  def result_items
    if keywords == "*"
      model.find(result.ids)
    else
      model.find(result.inlier_ids)
    end
  end

  private

  def build_query_object
    raise NotImplementedError
  end

  def build_keywords(query_object)
    raise NotImplementedError
  end

  def build_conditions(query_object)
    raise NotImplementedError
  end
end
