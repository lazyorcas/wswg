class AddOrganizerUrlToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :organizer_url, :string
  end
end

# UPDATE events
# SET organizer_url = REGEXP_REPLACE(url, '/events/.*$', '')
# WHERE url LIKE '%meetup.com%'
#     AND organizer_url IS NULL
