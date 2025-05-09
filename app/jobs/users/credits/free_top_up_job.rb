class Users::Credits::FreeTopUpJob < ApplicationJob
  queue_with_priority 4

  def perform
    User.where(credits: 0).find_each do |user|
      user.add_free_credits!
    end
  end
end
