class ChangeEventsUniquenessOrder < ActiveRecord::Migration[8.0]
  def change
    remove_index :events, column: [ :source_id, :uid ], unique: true
    add_index :events, [ :uid, :source_id ], unique: true
  end
end
