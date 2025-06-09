class Credits::FreeTopUpJob < ApplicationJob
  queue_as :default
  queue_with_priority 100

  def perform
    User.where(credits: 0).find_each(&:add_free_credits!)
    Visitor.where(credits: 0).find_each(&:add_free_credits!)
  end
end
