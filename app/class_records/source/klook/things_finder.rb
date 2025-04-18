class Source::Klook::ThingsFinder < Source::ThingsFinder
  private

  def max_page_count
    100
  end

  def get_things
    @browser.scroll_to_load

    @browser.css(".card_item").each do |link|
      url = link.attribute("href")

      @things << {
        uid: url.split("/").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @browser.at_css(".klk-pagination-next-btn").click
  end
end
