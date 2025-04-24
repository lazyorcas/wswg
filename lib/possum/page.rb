module Possum::Page
  def after_initialize
    self.headers.set(Config::HEADERS)
    reject_redundant_requests
  end

  def scroll_to_load
    execute("window.scrollTo({ top: #{Config::SCROLL_DISTANCE}, behavior: 'smooth' })")
  end

  def wait_for_idle
    network.wait_for_idle(timeout: Config::NETWORK_IDLE_TIMEOUT)
  end

  def click_on(selector)
    execute("document.querySelector('#{selector}').click()")
  end

  def reject_redundant_requests
    network.intercept
    on(:request) do |request|
      if Config::BLOCKED_FILETYPES.any? { |ext| request.url.end_with?(ext) }
        request.abort
      else
        request.continue
      end
    end
  end
end
