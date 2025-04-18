# https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html

class Current < ActiveSupport::CurrentAttributes
  attribute :account, :user
  attribute :request_id, :user_agent, :ip_address

  resets { Time.zone = nil }

  def user=(user)
    super
    self.account = user.account
    Time.zone    = user.city.time_zone
  end
end
