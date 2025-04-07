class Source::City::UrlFinder::Klook < Source::City::UrlFinder::Base
  REMOVE_PARAMS = [ "spm", "clickId" ]

  private

  def find_url_in_browser
    @browser.at_css("#banner-search").focus.type(@city.name)
    @browser.network.wait_for_idle(timeout: 2)

    @browser.at_css(".search-box-results .suggest-list[href*=\"city\"]").click

    @browser.current_url
  end
end
