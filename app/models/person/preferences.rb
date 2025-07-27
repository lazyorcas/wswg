module Person::Preferences
  extend ActiveSupport::Concern

  DEFAULT_SORT_BY = "time".freeze
  DEFAULT_HIDE_IMPRESSION_EVENTS = "show".freeze

  included do
    has_settings do |s|
      s.key :personalization
      s.key :preferences
    end
  end
end
