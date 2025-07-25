module BusinessesOnly
  extend ActiveSupport::Concern

  included do
    before_action :require_business_owner!
  end
end
