class UrlHandler
  def initialize(url)
    @url = url
  end

  def append_or_override_params(params)
    uri = URI(@url)

    query_param_hash = build_query_params_hash(uri)
    query_param_hash = { **query_param_hash, **params }

    uri.query = URI.encode_www_form(query_param_hash)
    uri.to_s
  end

  def remove_params(param_keys)
    uri = URI(@url)

    query_param_hash = build_query_params_hash(uri)
    query_param_hash.reject! { |key, value| param_keys.include?(key) }

    uri.query = query_param_hash.empty? ? nil : URI.encode_www_form(query_param_hash)
    uri.to_s
  end

  private

  def build_query_params_hash(uri)
    return {} if uri.query.nil?

    URI.decode_www_form(uri.query).to_h
  end
end
