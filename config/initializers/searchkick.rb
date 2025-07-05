if ENV["OPENSEARCH_HOST"].present?
  Searchkick.client_options = {
    hosts: [ ENV["OPENSEARCH_HOST"] ],
    transport_options: { ssl: { verify: false } }
  }
end
