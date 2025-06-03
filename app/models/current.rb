# https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html

class Current < ActiveSupport::CurrentAttributes
  attribute :request_id, :user_agent, :ip_address
  attribute :city
  attribute :visitor
  attribute :user
end
