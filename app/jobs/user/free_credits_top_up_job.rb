class User::FreeCreditsTopUpJob < ApplicationJob
  AMOUNT = 2

  queue_with_priority 4

  def perform
    User.where(credits: 0).find_each do |user|
      user.add_credits!(AMOUNT, transaction_type: :free_top_up)
    end
  end
end
