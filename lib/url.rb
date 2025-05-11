require "addressable/uri"

module Url
  def self.get_base_url(url)
    "https://#{parse(url).host}"
  end

  def self.build_url(base_url, path)
    Addressable::URI.join(base_url, path).to_s
  end

  def self.get_parameterized_url(url, params)
    uri = parse(url)
    query_values = params.to_a
    uri.query_values = query_values
    uri.to_s
  end

  def self.extract_query_param(url, key)
    uri = parse(url)
    uri.query_values[key]
  end

  def self.parse(url)
    Addressable::URI.parse(url)
  rescue Addressable::URI::InvalidURIError
    raise
  end
end
