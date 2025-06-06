module SearchQuery::Summarizable
  extend ActiveSupport::Concern

  def summary
    keywords = searches.pluck(:keywords).reject { |k| k == "*" }.join(" ").split(" ").uniq.join(" ")
    conditions = searches.first.conditions

    price = conditions.dig("price", "lte").presence
    start_date = conditions.dig("end_date", "gte").presence&.to_date&.strftime("%B %-d")
    end_date = conditions.dig("end_date", "lte").presence&.to_date&.strftime("%B %-d")
    start_time = conditions.dig("start_time", "gte").presence&.to_time&.strftime("%H:%M")
    end_time = conditions.dig("start_time", "lte").presence&.to_time&.strftime("%H:%M")

    summary_fragments = [ city.name ]
    summary_fragments << "with a max price of #{price}" if price.present?

    if start_date.present? && end_date.present?
      if start_date == end_date
        summary_fragments << "on #{start_date}"
      else
        summary_fragments << "between #{start_date} and #{end_date}"
      end
    elsif start_date.present?
      summary_fragments << "from #{start_date}"
    elsif end_date.present?
      summary_fragments << "until #{end_date}"
    end

    if start_time.present? && end_time.present?
      if start_time == end_time
        summary_fragments << "at #{start_time}"
      else
        summary_fragments << "at #{start_time} - #{end_time}"
      end
    elsif start_time.present?
      summary_fragments << "from #{start_time}"
    elsif end_time.present?
      summary_fragments << "until #{end_time}"
    end

    summary_fragments << "for keywords \"#{keywords}\"" if keywords.present?

    summary_fragments.join(" ")
  end
end
