class Source::MuenchenDe::ThingsFinder < Source::ThingsFinder
  private

  def max_page_count
    200
  end

  def get_things
    links = @browser.css(".m-event-list-item a")

    links.each do |link|
      url = link.attribute("href").split("?").first
      if url.start_with?("/")
        url = URI.join(base_url, url).to_s
      end

      @things << {
        uid: url.split("/").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @browser.at_css(".m-pagination__item.m-pagination__item--next-page a").click
  end
end
