Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :google_oauth2,
    ENV["GOOGLE_OAUTH2_CLIENT_ID"],
    ENV["GOOGLE_OAUTH2_CLIENT_SECRET"],
    access_type: "offline",
    scope: "email, profile",
    prompt: "consent"

  provider :linkedin,
    ENV["LINKEDIN_OAUTH2_CLIENT_ID"],
    ENV["LINKEDIN_OAUTH2_CLIENT_SECRET"],
    scope: "openid profile email",
    prompt: "consent"
end

OmniAuth.config.allowed_request_methods = %i[get post]
