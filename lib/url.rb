require "addressable/uri"

module Url
  def self.get_base_url(url)
    "https://#{parse(url).host}"
  end

  def self.build_url(base_url, path)
    Addressable::URI.join(base_url, path).to_s
  end

  def self.build_utm_url(url, campaign: nil, source: nil, medium: nil, content: nil)
    uri = parse(url)
    params = URI.decode_www_form(String(uri.query)).to_h
    params[:utm_campaign] = campaign if campaign.present?
    params[:utm_source] = source if source.present?
    params[:utm_medium] = medium if medium.present?
    params[:utm_content] = content if content.present?
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  def self.build_parameterized_url(url, params)
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
