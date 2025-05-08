class User::FreeCreditsTopUpJob < ApplicationJob
  FREE_CREDITS_AMOUNT = 2

  queue_with_priority 4

  def perform
    User.where(credits: 0).find_each do |user|
      user.add_credits!(FREE_CREDITS_AMOUNT, transaction_type: :free_top_up)
    end
  end
end
