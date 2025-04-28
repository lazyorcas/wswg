class RemoveCityFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_reference :events, :city, index: true, foreign_key: true
  end
end
