class Source::Klook::ThingsFinder < Source::ThingsFinder
  private

  def max_page_count
    100
  end

  def get_things
    @page.scroll_to_load

    @page.css(".card_item").each do |link|
      url = link.attribute("href")

      @things << {
        uid: url.split("/").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @page.click_on(".klk-pagination-next-btn")
  end
end
