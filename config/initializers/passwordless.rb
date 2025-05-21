Passwordless.configure do |config|
  config.default_from_address = ENV["GMAIL_NO_REPLY_SENDER_EMAIL"]
  config.parent_mailer = "ApplicationMailer"
  config.success_redirect_path = "/map"
  config.failure_redirect_path = "/login"
  config.sign_out_redirect_path = "/login"
end
