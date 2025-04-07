class Source::City::UrlFinder::Meetup < Source::City::UrlFinder::Base
  URL_PARAMS = {
    "eventType" => "inPerson",
    "source" => "EVENTS",
    "sortField" => "DATETIME"
  }

  private

  def find_url_in_browser
    search_bar = @browser.at_css("#location-bar-in-homepage")
    if search_bar.nil?
      search_bar = @browser.at_css("#location-typeahead-header-search")
    end

    search_bar.focus.type(@city.name)
    # @browser.network.wait_for_idle(timeout: 2)

    # @browser.at_css("#location-search-submit").click
    # @browser.network.wait_for_idle(timeout: 2)

    # url_handler = UrlHandler.new(@browser.current_url)
    # url_handler.append_or_override_params(URL_PARAMS)
  end
end
