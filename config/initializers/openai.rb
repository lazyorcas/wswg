OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_ACCESS_TOKEN"]

  # config.admin_token = ENV.fetch("OPENAI_ADMIN_TOKEN") # Optional, used for admin endpoints, created here: https://platform.openai.com/settings/organization/admin-keys

  # config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional

  if Rails.env.development?
    config.log_errors = true # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production because it could leak private data to your logs.
  end
end
