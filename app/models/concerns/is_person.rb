module IsPerson
  extend ActiveSupport::Concern

  included do
    has_settings do |s|
      s.key :personalization
      s.key :preferences, defaults: { sort_by: "popularity" }
    end

    belongs_to :city, optional: true
  end
end
