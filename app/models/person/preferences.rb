module Person::Preferences
  extend ActiveSupport::Concern

  DEFAULT_SORT_BY = "popularity".freeze

  included do
    has_settings do |s|
      s.key :personalization
      s.key :preferences, defaults: { sort_by: DEFAULT_SORT_BY }
    end
  end
end
