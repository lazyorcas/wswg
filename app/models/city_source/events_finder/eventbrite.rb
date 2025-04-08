class CitySource::EventsFinder::Eventbrite < CitySource::EventsFinder::Base
  private

  def find_events_in_browser
    @browser.css("a.event-card-link").each do |link|
      url = link.attribute("href")

      @events << {
        uid: url.split("?").first.split("/").last.split("-").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @browser.at_css("[aria-label=\"Next Page\"]").click
  end
end
