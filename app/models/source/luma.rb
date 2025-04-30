class Source::Luma
  def self.build_unique_url_for_event(event)
    url = event.url
    date = event.start_date

    Url.get_parameterized_url(url, { date: date })
  end
end
