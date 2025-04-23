class SearchQuery < ApplicationRecord
  include Broadcastable

  enum :status, {
    analyzing: 0,
    completed: 1,
    failed: -1,
    searching: 2
  }, default: :analyzing

  belongs_to :user

  has_many :searches

  validates :query, presence: true
  validates :status, presence: true

  after_commit :queue_create_searches, on: :create
  after_commit :broadcast_completed, on: :update, if: -> { status_previously_changed?(to: :completed) }

  def queue_create_searches
    CreateSearchesJob.perform_later(id)
  end

  def create_searches!
    query_object = build_query_object

    if query_object["thing_types"].empty?
      Sentry.capture_message(
        "Thing types are empty",
        level: :warning,
        extra: { search_query_id: id }
      )
    end

    keywords = build_keywords(query_object)
    conditions = build_conditions(query_object)

    Search.create!(
      search_query: self,
      model_type: query_object["thing_types"].first || "Event",
      keywords: keywords,
      conditions: conditions
    )

    self.status = :searching
    save!
  rescue => e
    Sentry.capture_exception(e)

    self.status = :failed
    save!

    if e.is_a?(UserReadableError)
      broadcast_error(e.message)
    else
      broadcast_error("Failed to search. Try again.")
    end

    broadcast_update_to(self, target: "search-results", html: "")
  end

  def done_searching?
    searches.pluck(:status).all? { |status| status == "completed" }
  end

  def result_things
    things = []

    if searches.pluck(:keywords).all? { |keywords| keywords == "*" }
      things = searches.map { |search| search.model.where(id: search.result.ids).order(:start_date, :start_time) }.flatten
    else
      searches.each do |search|
        scores = search.result.scores
        things += search.model.find(search.result.ids).map.with_index do |thing, index|
          { thing: thing, score: scores[index] }
        end
      end

      things = things.sort_by { |thing| thing[:score] }.reverse.map { |thing| thing[:thing] }
    end

    things
  end

  def took_in_seconds
    searches.where(status: :completed).sum { |search| search.result.took_in_seconds }
  end

  private

  def build_keywords(query_object)
    keywords_arr = query_object["keywords"]
      # .gsub(/events?|things? to do/, "")
      .split(" ")
      .reject(&:blank?)

    keywords_arr << "*" if keywords_arr.empty?
    keywords_arr.join(" ")
  end

  def build_conditions(query_object)
    query_city = query_object.dig("city")

    if query_city == "NOT_SUPPORTED"
      Sentry.capture_message(
        "Location not supported",
        level: :warning,
        extra: { search_id: id }
      )

      raise UserReadableError.new(
        "This location is not supported yet. Only #{City.pluck(:name).map { |name| "<b>#{name}</b>" }.to_sentence} are currently supported.".html_safe
      )
    end

    city = City.find_by(name: query_object.dig("city")) || user.city
    today = Time.current.in_time_zone(city.time_zone).to_date

    query_start_date = query_object.dig("date_range", "start_date").presence
    if query_start_date.blank? || query_start_date < today.to_s
      query_start_date = today.to_s
    end

    {
      city_id: city.id,
      end_date: {
        gte: query_start_date,
        lte: query_object.dig("date_range", "end_date").presence
      },
      start_time: {
        gte: query_object.dig("date_range", "start_time").presence,
        lte: query_object.dig("date_range", "end_time").presence
      },
      price: {
        lte: query_object.dig("max_price") == -1 ? nil : query_object.dig("max_price")
      }
    }
  end

  def build_query_object
    local_guide.build_search_query(query,
      json_schema: json_schema,
      time_zone: user.city.time_zone
    )
  end

  def json_schema
    @json_schema ||= OpenAI::Responses::Schemas.search_query_schema
  end

  def local_guide
    @local_guide ||= OpenAI::Assistants::LocalGuide.new
  end
end
