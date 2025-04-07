class Search < ApplicationRecord
  enum :status, {
    processing: 0,
    completed: 1,
    failed: -1
  }, default: :processing

  attribute :result, Search::Result.to_type

  validates :public_id, presence: true, uniqueness: true
  validates :query, presence: true
  validates :status, presence: true

  with_options if: :completed? do
    validates :keywords, presence: true
    validates :conditions, presence: true
    validates :result, presence: true
  end

  before_validation :generate_public_id, on: :create

  after_commit :queue_query, on: :create

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

      result = searchable_class.search(
        self.keywords,
        where: self.conditions.deep_symbolize_keys,
        load: false
      )

      self.result.ids = result.to_a.map(&:id)
      self.result.took = result.took
      self.result.count = result.total_count

      self.status = :completed
    rescue => e
      self.result.error = e.message
      self.status = :failed
    end

    save!
  end

  private

  def generate_public_id
    self.public_id = SecureRandom.uuid
  end

  def build_query_object
    search_query_builder.build_search_query(query, json_schema: json_schema)
  end

  def searchable_class
    raise NotImplementedError
  end

  def build_keywords(query_object)
    raise NotImplementedError
  end

  def build_conditions(query_object)
    raise NotImplementedError
  end

  def json_schema
    raise NotImplementedError
  end

  def search_query_builder
    @search_query_builder ||= OpenAI::Assistants::SearchQueryBuilder.new
  end
end
