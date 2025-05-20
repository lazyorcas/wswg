# https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html

class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :request_id, :user_agent, :ip_address
end
