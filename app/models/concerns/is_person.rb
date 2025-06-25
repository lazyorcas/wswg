module IsPerson
  extend ActiveSupport::Concern

  included do
    has_settings :personalization

    belongs_to :city, optional: true
  end
end
