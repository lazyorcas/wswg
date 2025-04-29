module Possum::Page
  def after_initialize
    self.headers.set(Config::HEADERS)
    reject_redundant_requests
  end

  def scroll_to_load
    execute("window.scrollTo({ top: #{Config::SCROLL_DISTANCE}, behavior: 'smooth' })")
  end

  def wait_for_idle(timeout: Config::NETWORK_IDLE_TIMEOUT)
    network.wait_for_idle(timeout: timeout)
  end

  def click_on(selector)
    execute("document.querySelector('#{selector}').click()")
  end

  def reject_redundant_requests
    network.intercept
    on(:request) do |request|
      if Config::BLOCKED_FILETYPES.any? { |ext| request.url.include?(ext) }
        request.abort
      else
        request.continue
      end
    end
  end

  def end_of_page?
    current_scroll = evaluate("window.pageYOffset + window.innerHeight")
    total_height = evaluate("document.documentElement.scrollHeight")
    current_scroll >= total_height
  end
end
