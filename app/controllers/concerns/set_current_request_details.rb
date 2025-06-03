module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action unless: -> { browser.bot? } do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
      Current.visitor = Visitor.find_by(visitor_token: ahoy.visitor_token)
    end
  end
end
