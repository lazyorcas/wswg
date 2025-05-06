if Rails.env.production?
  Searchkick.client_options = {
    hosts: [ ENV["OPENSEARCH_HOST"] ],
    transport_options: { ssl: { verify: false } }
  }
end

Rails.application.config.after_initialize do
  if ActiveRecord::Base.connection.data_source_exists?("languages")
    Language.define_searchable_event_classes
  end
end
