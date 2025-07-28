module Business::EventQuery::QueryByKeywords
  extend ActiveSupport::Concern

  LIMIT = 1000

  def query_by_keywords
    puts "dow: #{dow}, start_time: #{start_time}, end_time: #{end_time}, city_id: #{city_id}, source_id: #{source_id}"

    @events = Searchable::EventByKeywords
      .search(keywords,
        where: build_search_conditions,
        limit: LIMIT
      )
  end

  def build_search_conditions
    conditions = {}

    conditions[:start_time] = {
      gte: start_time,
      lte: end_time
    }

    conditions[:dow] = dow if dow.present?
    conditions[:city_id] = city_id if city_id.present?
    conditions[:source_id] = source_id if source_id.present?

    conditions
  end
end
