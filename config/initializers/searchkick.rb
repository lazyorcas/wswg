if Rails.env.production?
  Searchkick.client_options = {
    hosts: [ ENV["OPENSEARCH_HOST"] ],
    transport_options: { ssl: { verify: false } }
  }
end
