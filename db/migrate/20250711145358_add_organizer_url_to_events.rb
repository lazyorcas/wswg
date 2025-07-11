class AddOrganizerUrlToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :organizer_url, :string
  end
end
