class Source::Luma::EventsFinder < Source::EventsFinder
  UID_DELIMITER = "___"

  # Luma's event URLs are not unique, so we need to add the date to the UID
  def self.build_uid(id, date: Time.current.to_date)
    "#{id}#{UID_DELIMITER}#{date}"
  end

  def self.get_id(uid)
    uid.split(UID_DELIMITER).first
  end

  private

  def max_page_count
    10
  end

  def get_events
    @page.css("a.event-link").each do |link|
      path = link.attribute("href")
      id = path[1..]

      @events << {
        uid: self.class.build_uid(id),
        url: URI.join(base_url, path).to_s
      }
    end
  end

  def go_to_next_page
    @page.scroll_to_load
  end

  def done?
    end_of_page?
  end
end
