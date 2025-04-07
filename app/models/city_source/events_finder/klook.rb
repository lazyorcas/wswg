class CitySource::EventsFinder::Klook < CitySource::EventsFinder::Base
  private

  def find_events_in_browser
    browser_scroll_to_load

    @browser.css(".card_item").each do |link|
      url = link.attribute("href")

      @events << {
        uid: url.split("/").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @browser.at_css(".klk-pagination-next-btn").click
  end
end
