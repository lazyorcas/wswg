class AddFinalizableFromAndFinalizableUntilToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :finalizable_from, :datetime
    add_column :events, :finalizable_until, :datetime
  end
end
