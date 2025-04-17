class Source::Luma::ThingsFinder < Source::ThingsFinder
  private

  def max_page_count
    10
  end

  def get_things
    host = URI.join(@source.url).host
    base_url = "https://#{host}"

    @browser.css("a.event-link").each do |link|
      path = link.attribute("href")

      @things << {
        uid: path[1..],
        url: URI.join(base_url, path).to_s
      }
    end
  end

  def go_to_next_page
    browser_scroll_to_load
  end

  def done?
    end_of_page?
  end
end
