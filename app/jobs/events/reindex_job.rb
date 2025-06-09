class Events::ReindexJob < ApplicationJob
  queue_as :default
  queue_with_priority 1

  def perform
    Language.find_each do |language|
      searchable_class = "Searchable::#{language.name.capitalize}Event"
      searchable_class.constantize.reindex
    end
  end
end
