module Url
  def self.get_base_url(url)
    "https://#{parse(url).host}"
  end

  def self.build_url(base_url, path)
    URI.join(base_url, path).to_s
  end

  def self.get_parameterized_url(url, params)
    uri = parse(url)
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  def self.extract_query_param(url, key)
    uri = parse(url)
    query_params = URI.decode_www_form(uri.query)
    query_params.to_h[key]
  end

  def self.parse(url)
    URI.parse(url)

  rescue URI::InvalidURIError
    uri = URI.parse(url.split("?").first)

    if url.include?("?")
      query = url.split("?").last
      uri.query = URI.encode_www_form_component(query)
    end

    uri
  end
end
