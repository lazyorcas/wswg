module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip

      if browser.bot? || ahoy.exclude?
        Current.visitor = Visitor.new(visitor_token: ahoy.visitor_token)
      else
        Current.visitor = Visitor.find_or_create_by(visitor_token: ahoy.visitor_token)
      end
    end
  end
end
