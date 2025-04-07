class Source::City::UrlFinder::Eventbrite < Source::City::UrlFinder::Base
  private

  def find_url_in_browser
    @browser.at_css("#location-autocomplete").focus.type(@city.name)
    @browser.network.wait_for_idle(timeout: 2)

    @browser.at_css(".eds-text-list-item__button").click
    @browser.network.wait_for_idle(timeout: 2)

    @browser.at_css("[class^='SearchBar-module__desktopSearchBarRightSide___'] button.searchButton").click

    @browser.current_url
  end
end
