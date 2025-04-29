class SearchQuery < ApplicationRecord
  include Broadcastable

  EVENT_COUNT_LIMIT = 1000
  SEARCH_RADIUS_IN_KM = 30

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
    city_response = detect_city
    city_name = city_response.dig("city")

    if city_name == "NOT_SUPPORTED"
      Sentry.capture_message(
        "Location not supported",
        level: :warning,
        extra: { search_id: id }
      )

      raise UserReadableError.new(
        "This location is not supported yet. Only #{City.pluck(:name).map { |name| "<b>#{name}</b>" }.to_sentence} are currently supported.".html_safe
      )
    end

    city = City.find_by(name: city_name) || user.city

    query_object = build_query_object(city: city)

    language_keywords = build_language_keywords(query_object)
    conditions = build_conditions(query_object)

    language_keywords.each do |language, keywords|
      begin
        Search.create!(
          search_query: self,
          searchable_type: "Searchable::#{language.capitalize}::Event",
          keywords: keywords,
          conditions: conditions
        )
      rescue => e
        Sentry.capture_exception(e)
      end
    end

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

  def result_events
    events = []

    if searches.pluck(:keywords).all? { |keywords| keywords == "*" }
      events = searches
        .map { |search| Event.where(id: search.result.ids).order(:start_date, :start_time) }
        .flatten
        .take(EVENT_COUNT_LIMIT)

    else
      searches.each do |search|
        scores = search.result.scores
        events += Event.find(search.result.inlier_ids).map.with_index do |event, index|
          { event: event, score: scores[index] }
        end
      end

      events = events
        .sort_by { |event| event[:score] }
        .reverse
        .map { |event| event[:event] }
        .take(EVENT_COUNT_LIMIT)
    end

    # remove duplicates
    events = events.uniq

    events
  end

  def took_in_seconds
    searches.where(status: :completed).sum { |search| search.result.took_in_seconds }
  end

  private

  def build_language_keywords(query_object)
    lks = {}

    query_object["language_keywords"].each do |language_keyword|
      keywords_arr = language_keyword["keywords"]
        .split(" ")
        .reject(&:blank?)

      keywords_arr << "*" if keywords_arr.empty?
      keywords = keywords_arr.join(" ")

      lks[language_keyword["language"]] = keywords
    end

    # if there are multiple keywords with "*" and no other keywords
    if lks.select { |_, keywords| keywords == "*" }.length == lks.length
      lks = { "English" => "*" }

    # if there are multiple keywords with "*" and other keywords
    elsif lks.select { |_, keywords| keywords == "*" }.length > 1
      Sentry.capture_message(
        "Some keywords are empty",
        level: :warning,
        extra: { search_query_id: id }
      )

      lks = lks.reject { |_, keywords| keywords == "*" }
    end

    lks
  end

  def build_conditions(query_object)
    {
      location: {
        near: query_object.dig("date_range", "start_date").presence,
        within: "#{SEARCH_RADIUS_IN_KM}km"
      },
      end_date: {
        gte: query_object.dig("date_range", "start_date").presence,
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

  def detect_city
    local_guide.detect_city(query)
  end

  def build_query_object(city:)
    local_guide.build_search_query(query, city: city)
  end

  def local_guide
    @local_guide ||= OpenAI::Assistants::LocalGuide.new
  end
end
