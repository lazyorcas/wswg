class Url
  def self.get_base_url(url)
    "https://#{URI(url).host}"
  end

  def self.build_url(base_url, path)
    URI.join(base_url, path).to_s
  end
end
