module Url
  def self.get_base_url(url)
    "https://#{URI(url).host}"
  end

  def self.build_url(base_url, path)
    URI.join(base_url, path).to_s
  end

  def self.get_parameterized_url(url, params)
    url = URI(url)
    url.query = URI.encode_www_form(params)
    url.to_s
  end
end
