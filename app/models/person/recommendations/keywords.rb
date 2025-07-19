module Person::Recommendations::Keywords
  extend ActiveSupport::Concern

  WEIGHTS = [ 0.9, 0.6 ].freeze

  def build_weighted_keywords
    keywords_tsvector = get_keywords_tsvector_from_events(seen_events)
    keywords = extract_keywords_from_tsvector(keywords_tsvector)
    weight_groups = split_keywords_into_weight_groups(keywords)
    weight_groups.map { |weight_group| weight_group.join(" ") }.reject(&:blank?)
  end

  private

  def get_keywords_tsvector_from_events(events)
    events.select("to_tsvector(title) AS keywords").map(&:keywords).join(" ")
  end

  def extract_keywords_from_tsvector(tsvector)
    tsvector.scan(/'([^\d'][^']*)':([0-9,]+)/)
      .group_by(&:first)
      .map do |word, word_positions|
        occurrences = word_positions.map(&:second).join(",").split(",").length
        [ word, occurrences ]
      end
  end

  def split_keywords_into_weight_groups(keywords)
    sorted_keywords = keywords.sort_by { |_, occurrences| occurrences }.reverse
    max_occurrences = sorted_keywords.first.last

    remaining_keywords = sorted_keywords.dup
    weight_groups = []

    WEIGHTS.each_with_index do |weight, idx|
      weight_group = remaining_keywords.select do |_, occurrences|
        occurrences >= max_occurrences * weight
      end
      weight_groups << weight_group
      remaining_keywords -= weight_group
    end

    weight_groups.map do |weight_group|
      weight_group.map(&:first)
    end
  end
end
