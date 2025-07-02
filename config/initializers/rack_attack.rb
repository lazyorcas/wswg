class Rack::Attack
  ### Configure Cache ###

  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  #
  # Note: The store is only used for throttling (not blocklisting and
  # safelisting). It must implement .increment and .write like
  # ActiveSupport::Cache::Store

  # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.match?(/\/events\/[0-9]+\/bookmark/)
  end

  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:login/ip:#{req.ip}"
  throttle("login/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/login"  && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /users by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:users/ip:#{req.ip}"
  throttle("users/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/users"  && req.post?
      req.ip
    end
  end

  # Throttle POST requests to /passwordless/sign_in by email param
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:passwordless_sign_in/email:#{normalized_email}"
  #
  # Note: This creates a problem where a malicious user could intentionally
  # throttle logins for another user and force their login requests to be
  # denied, but that's not very common and shouldn't happen to you. (Knock
  # on wood!)
  throttle("passwordless_sign_in/email", limit: 5, period: 20.seconds) do |req|
    if req.path == "/passwordless/sign_in" && req.post?
      # Normalize the email, using the same logic as your authentication process, to
      # protect against rate limit bypasses. Return the normalized email if present, nil otherwise.
      req.params["email"].to_s.downcase.gsub(/\s+/, "").presence
    end
  end

  # Throttle PATCH requests to /passwordless/sign_in by IP
  # #
  # Key: "rack::attack:#{Time.now.to_i/:period}:confirm_passwordless_sign_in/ip:ip"
  throttle("confirm_passwordless_sign_in/ip", limit: 5, period: 20.seconds) do |req|
    if req.path.start_with?("/passwordless/sign_in/") && req.patch?
      req.ip
    end
  end

  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  # self.throttled_responder = lambda do |env|
  #  [ 503,  # status
  #    {},   # headers
  #    ['']] # body
  # end

  # Throttle POST requests to /(map/)search_queries by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:search_queries/ip:#{req.ip}"
  throttle("search_queries/ip", limit: 100, period: 5.minutes) do |req|
    if (req.path.start_with?("/search_queries") || req.path.start_with?("/map/search_queries")) && req.post?
      req.ip
    end
  end

  ## Throttle GET requests to /map by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:map/ip:#{req.ip}"
  throttle("map/ip", limit: 100, period: 5.minutes) do |req|
    if req.path.start_with?("/map") && req.get?
      req.ip
    end
  end
end

if Rails.env.development?
  Rack::Attack.enabled = false
end
