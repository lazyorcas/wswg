module BusinessesOnly
  extend ActiveSupport::Concern

  included do
    before_action :require_business_owner!, unless: :admin?
    before_action -> { head(:bad_request) }, if: -> { admin? && Current.business.nil? }
  end
end
