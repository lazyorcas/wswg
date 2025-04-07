class CitySource::EventsFinder::Luma < CitySource::EventsFinder::Base
  private

  def find_events_in_browser
    host = URI.join(@city_source.url).host
    base_url = "https://#{host}"

    @browser.css("a.event-link").each do |link|
      path = link.attribute("href")

      @events << {
        uid: path[1..],
        url: URI.join(base_url, path).to_s
      }
    end
  end

  def go_to_next_page
    browser_scroll_to_load
  end
end
