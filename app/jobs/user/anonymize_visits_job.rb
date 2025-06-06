class User::AnonymizeVisitsJob < ApplicationJob
  def perform(user_id)
    user = User.find(user_id)
    user.anonymize_visits!
  end
end
