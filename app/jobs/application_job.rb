class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  private

  def log(message)
    Rails.logger.info("#{self.class.name} - #{message}")
  end

  def log_error(message)
    Rails.logger.error("#{self.class.name} - Error: #{message}")
  end
end
