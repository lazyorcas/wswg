class SearchQuerySchema < RubyLLM::Schema
  array :language_keywords do
    object do
      string :language, enum: Language.pluck(:name)
      string :keywords, description: "Keywords that will be input to Elasticsearch. Each keyword should be separated by a blank space. The keywords should be downcased."
    end
  end

  object :date_range do
    any_of :start_date, description: "Start date in YYYY-MM-DD format. Use null if unknown." do
      string
      null
    end
    any_of :start_time, description: "Start time in HH:mm:ss format. Use null if unknown." do
      string
      null
    end
    any_of :end_date, description: "End date in YYYY-MM-DD format. Use null if unknown." do
      string
      null
    end
    any_of :end_time, description: "End time in HH:mm:ss format. Use null if unknown." do
      string
      null
    end
  end

  any_of :max_price, description: "If free, return 0. Use null if unknown." do
    number
    null
  end
end
