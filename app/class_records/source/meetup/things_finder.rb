class Source::Meetup::ThingsFinder < Source::ThingsFinder
  private

  def max_page_count
    100
  end

  def get_things
    links = @browser.css("[data-element-name=\"categoryResults-eventCard\"] a")

    # old selector
    if links.empty?
      links = @browser.css("a#event-card-in-search-results")
    end

    links.each do |link|
      url = link.attribute("href").split("?").first

      @things << {
        uid: url.split("/").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @browser.scroll_to_load
  end

  def done?
    end_of_page?
  end
end
