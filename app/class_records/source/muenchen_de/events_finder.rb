class Source::MuenchenDe::EventsFinder < Source::EventsFinder
  private

  def max_page_count
    200
  end

  def get_events
    links = @page.css(".m-event-list-item a")

    links.each do |link|
      url = link.attribute("href").split("?").first
      if url.start_with?("/")
        url = URI.join(base_url, url).to_s
      end

      @events << {
        uid: url.split("/").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @page.click_on(".m-pagination__item.m-pagination__item--next-page a")
  end
end
