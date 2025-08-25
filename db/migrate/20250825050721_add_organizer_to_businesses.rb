class AddOrganizerToBusinesses < ActiveRecord::Migration[8.0]
  def change
    add_reference :businesses, :organizer, foreign_key: true
  end
end
