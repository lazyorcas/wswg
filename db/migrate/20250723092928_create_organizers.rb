class CreateOrganizers < ActiveRecord::Migration[8.0]
  def change
    create_table :organizers do |t|
      t.belongs_to :source, foreign_key: true, index: true

      t.string :name
      t.string :url, index: { unique: true }

      t.timestamps
    end

    add_index :organizers, [ :source_id, :url, :name ], unique: true
    add_reference :events, :organizer, foreign_key: true, index: true
  end
end

# Event.where.not(organizer_url: nil).where(organizer_id: nil).find_each do |event|
#   begin
#     event.assign_organizer!
#   rescue => e
#     puts "#{event.id} - #{event.organizer_url} - #{event.organizer_name}"
#   end
# end
# Event.where.not(organizer_name: nil).where(organizer_id: nil).find_each do |event|
#   begin
#     event.assign_organizer!
#   rescue => e
#     puts "#{event.id} - #{event.organizer_url} - #{event.organizer_name}"
#   end
# end
