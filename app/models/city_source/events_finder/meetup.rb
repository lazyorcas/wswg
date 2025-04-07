class CitySource::EventsFinder::Meetup < CitySource::EventsFinder::Base
  private

  def find_events_in_browser
    links = @browser.css("*[data-element-name=\"categoryResults-eventCard\"] a")

    # old selector
    if links.empty?
      links = @browser.css("a#event-card-in-search-results")
    end

    links.each do |link|
      url = link.attribute("href").split("?").first

      @events << {
        uid: url.split("/").last,
        url: url
      }
    end
  end

  def go_to_next_page
    browser_scroll_to_load
  end
end
