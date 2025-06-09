class User::AnonymizeVisitsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.anonymize_visits!
  end
end
